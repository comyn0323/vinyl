import Foundation

#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

final class FirestoreService {
    static let shared = FirestoreService()

    private init() {}

    func updateSharingEnabled(uid: String, isEnabled: Bool) async throws {
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        try await db.collection("users").document(uid).setData([
            "sharingEnabled": isEnabled,
            "updatedAt": Timestamp(date: Date())
        ], merge: true)
        #else
        throw NSError(domain: "FirestoreMissing", code: 1)
        #endif
    }

    func setLiveActivityPushToken(uid: String, token: String) async throws {
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        try await db.collection("liveActivityTokens").document(uid).setData([
            "pushToken": token,
            "updatedAt": Timestamp(date: Date())
        ], merge: true)
        #else
        throw NSError(domain: "FirestoreMissing", code: 1)
        #endif
    }

    func listenPresence(for friendIds: [String]) -> AsyncStream<[Presence]> {
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        return AsyncStream { continuation in
            guard !friendIds.isEmpty else {
                continuation.yield([])
                return
            }
            let query = db.collection("presence").whereField(FieldPath.documentID(), in: friendIds)
            let listener = query.addSnapshotListener { snapshot, error in
                if let snapshot {
                    let items: [Presence] = snapshot.documents.compactMap { doc in
                        let data = doc.data()
                        return Presence(
                            uid: doc.documentID,
                            trackId: data["trackId"] as? String ?? "",
                            trackName: data["trackName"] as? String ?? "",
                            artistName: data["artistName"] as? String ?? "",
                            albumArtUrl: data["albumArtUrl"] as? String ?? "",
                            isPlaying: data["isPlaying"] as? Bool ?? false,
                            progressMs: data["progressMs"] as? Int ?? 0,
                            updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date(),
                            rawSpotifyUri: data["rawSpotifyUri"] as? String
                        )
                    }
                    continuation.yield(items)
                } else if error != nil {
                    continuation.finish()
                }
            }
            continuation.onTermination = { _ in
                listener.remove()
            }
        }
        #else
        return AsyncStream { continuation in
            continuation.yield([])
        }
        #endif
    }

    func fetchPins(uid: String) async throws -> [String] {
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        let snapshot = try await db.collection("pins").document(uid).getDocument()
        return snapshot.data()?["pinned"] as? [String] ?? []
        #else
        return []
        #endif
    }

    func fetchIncomingRequests(uid: String) async throws -> [FriendRequest] {
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        let snapshot = try await db.collection("friendRequests")
            .whereField("toUid", isEqualTo: uid)
            .whereField("status", isEqualTo: "pending")
            .getDocuments()

        return snapshot.documents.map { doc in
            let data = doc.data()
            return FriendRequest(
                id: doc.documentID,
                fromUid: data["fromUid"] as? String ?? "",
                toUid: data["toUid"] as? String ?? "",
                status: data["status"] as? String ?? "pending",
                createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
            )
        }
        #else
        return []
        #endif
    }

    func fetchOutgoingRequests(uid: String) async throws -> [FriendRequest] {
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        let snapshot = try await db.collection("friendRequests")
            .whereField("fromUid", isEqualTo: uid)
            .whereField("status", isEqualTo: "pending")
            .getDocuments()

        return snapshot.documents.map { doc in
            let data = doc.data()
            return FriendRequest(
                id: doc.documentID,
                fromUid: data["fromUid"] as? String ?? "",
                toUid: data["toUid"] as? String ?? "",
                status: data["status"] as? String ?? "pending",
                createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
            )
        }
        #else
        return []
        #endif
    }

    func fetchFriends(uid: String) async throws -> [Friend] {
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        let snapshot = try await db.collection("friends").document(uid).collection("list").getDocuments()
        return snapshot.documents.map { doc in
            let data = doc.data()
            return Friend(
                uid: doc.documentID,
                displayName: data["displayName"] as? String ?? "Friend",
                photoUrl: data["photoUrl"] as? String
            )
        }
        #else
        return []
        #endif
    }
}
