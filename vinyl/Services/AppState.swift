import ActivityKit
import Foundation
import Observation

@MainActor
@Observable
final class AppState {
    var isAuthenticated = false
    var isSharingEnabled = false
    var isLoading = false
    var errorMessage: String?

    var friends: [Friend] = []
    var pinnedFriendIds: [String] = []
    var pinnedPresences: [Presence] = []
    var incomingRequests: [FriendRequest] = []
    var outgoingRequests: [FriendRequest] = []
    var connectedProvider: MusicProvider? = nil

    private let authService = SpotifyAuthService()
    private let backend = BackendClient()
    private let firebase = FirebaseManager.shared
    private let firestore = FirestoreService.shared

    private var presenceTask: Task<Void, Never>?
    private var liveActivity: Activity<VinylLiveActivityAttributes>?

    func configure() {
        firebase.configureIfNeeded()
        isAuthenticated = firebase.currentUserId != nil
    }

    func signInWithSpotify() async {
        isLoading = true
        errorMessage = nil
        do {
            let authResult = try await authService.authorize()
            try await firebase.signInWithCustomToken(authResult.firebaseCustomToken)
            connectedProvider = .spotify
            isAuthenticated = true
            isLoading = false
            await refreshAll()
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    func refreshAll() async {
        await refreshFriends()
        await refreshPins()
        await refreshRequests()
        listenToPresence()
    }

    func toggleSharing(isOn: Bool) async {
        guard let uid = firebase.currentUserId else { return }
        isLoading = true
        errorMessage = nil
        do {
            try await firestore.updateSharingEnabled(uid: uid, isEnabled: isOn)
            isSharingEnabled = isOn
            if isOn {
                await registerLiveActivityPushTokens()
            } else {
                await LiveActivityService.shared.stopAll()
                liveActivity = nil
            }
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    func refreshFriends() async {
        guard let uid = firebase.currentUserId else { return }
        do {
            friends = try await firestore.fetchFriends(uid: uid)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refreshPins() async {
        guard let uid = firebase.currentUserId else { return }
        do {
            pinnedFriendIds = try await firestore.fetchPins(uid: uid)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refreshRequests() async {
        guard let uid = firebase.currentUserId else { return }
        do {
            incomingRequests = try await firestore.fetchIncomingRequests(uid: uid)
            outgoingRequests = try await firestore.fetchOutgoingRequests(uid: uid)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func listenToPresence() {
        presenceTask?.cancel()
        let friendIds = pinnedFriendIds
        presenceTask = Task { @MainActor in
            for await list in firestore.listenPresence(for: friendIds) {
                pinnedPresences = list
                AppGroupCache.shared.savePresenceList(list)
            }
        }
    }

    func sendFriendRequest(toUid: String) async {
        guard let uid = firebase.currentUserId else { return }
        struct Response: Decodable { let success: Bool }
        do {
            _ = try await backend.postJson("/sendRequest", body: [
                "fromUid": uid,
                "toUid": toUid
            ]) as Response
            await refreshRequests()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func respondFriendRequest(requestId: String, accept: Bool) async {
        struct Response: Decodable { let success: Bool }
        do {
            _ = try await backend.postJson("/respondRequest", body: [
                "requestId": requestId,
                "action": accept ? "accepted" : "rejected"
            ]) as Response
            await refreshFriends()
            await refreshRequests()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func togglePin(friendUid: String) async {
        guard let uid = firebase.currentUserId else { return }
        var next = pinnedFriendIds
        if let index = next.firstIndex(of: friendUid) {
            next.remove(at: index)
        } else {
            guard next.count < 5 else {
                errorMessage = "핀은 최대 5명까지 가능합니다."
                return
            }
            next.append(friendUid)
        }

        struct Response: Decodable { let success: Bool }
        do {
            _ = try await backend.postJson("/updatePins", body: [
                "uid": uid,
                "pinned": next
            ]) as Response
            pinnedFriendIds = next
            listenToPresence()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func removeFriend(friendId: String) async {
        errorMessage = "친구 삭제는 곧 추가됩니다."
    }

    func connectProvider(_ provider: MusicProvider) async {
        guard provider.isAvailableInMvp else {
            errorMessage = "MVP에서는 Spotify만 지원합니다."
            return
        }
        await signInWithSpotify()
    }

    func disconnectProvider() {
        connectedProvider = nil
        errorMessage = "연결 해제는 아직 지원되지 않습니다."
    }

    func registerLiveActivityPushTokens() async {
        guard let uid = firebase.currentUserId else { return }
        if liveActivity == nil {
            let placeholder = Presence(
                uid: uid,
                trackId: "placeholder",
                trackName: "Listening on Spotify",
                artistName: "vinyl",
                albumArtUrl: "",
                isPlaying: true,
                progressMs: 0,
                updatedAt: Date(),
                rawSpotifyUri: nil
            )
            liveActivity = try? await LiveActivityService.shared.startIfNeeded(track: placeholder)
        }

        guard let liveActivity else { return }

        for await token in liveActivity.pushTokenUpdates {
            let tokenString = token.map { String(format: "%02x", $0) }.joined()
            do {
                try await firestore.setLiveActivityPushToken(uid: uid, token: tokenString)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
