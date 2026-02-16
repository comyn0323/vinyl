import SwiftUI

struct HomeView: View {
    @State private var appState = AppState()
    @Environment(\.openURL) private var openURL

    private var pinnedFriends: [FriendDisplay] {
        if appState.pinnedPresences.isEmpty {
            return []
        }

        return appState.pinnedPresences.map { presence in
            FriendDisplay(
                id: presence.uid,
                name: presence.uid,
                isPinned: true,
                nowPlaying: Track(
                    title: presence.trackName,
                    artist: presence.artistName,
                    albumArtUrl: presence.albumArtUrl,
                    isPlaying: presence.isPlaying,
                    rawSpotifyUri: presence.rawSpotifyUri
                )
            )
        }
    }

    private var allFriends: [FriendDisplay] {
        if appState.friends.isEmpty { return [] }

        return appState.friends.map { friend in
            FriendDisplay(
                id: friend.uid,
                name: friend.displayName,
                isPinned: appState.pinnedFriendIds.contains(friend.uid),
                nowPlaying: nil
            )
        }
    }

    var body: some View {
        ZStack {
            VinylColors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: VinylSpacing.lg) {
                    pinnedSection
                    allFriendsSection
                }
                .padding(VinylSpacing.md)
            }
        }
        .navigationTitle("vinyl")
        .toolbarBackground(VinylColors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            appState.configure()
            Task { await appState.refreshAll() }
        }
    }

    private var pinnedSection: some View {
        VStack(alignment: .leading, spacing: VinylSpacing.sm) {
            Text("Pinned")
                .font(.headline)
                .foregroundStyle(VinylColors.textPrimary)

            if pinnedFriends.isEmpty {
                EmptyStateView(
                    title: "핀을 꽂아보세요",
                    subtitle: "핀한 친구의 음악만 위젯과 Live Activity에 표시됩니다.",
                    actionTitle: "친구 요청",
                    action: {}
                )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: VinylSpacing.md) {
                        ForEach(pinnedFriends) { friend in
                            PinnedFriendChip(friend: friend)
                                .onTapGesture {
                                    if let uri = friend.nowPlaying?.rawSpotifyUri, let url = URL(string: uri) {
                                        openURL(url)
                                    }
                                }
                                .contextMenu {
                                    Button("핀 해제") {
                                        Task { await appState.togglePin(friendUid: friend.id) }
                                    }
                                    Button("Open in Spotify") {
                                        if let uri = friend.nowPlaying?.rawSpotifyUri, let url = URL(string: uri) {
                                            openURL(url)
                                        }
                                    }
                                }
                        }
                    }
                }
            }
        }
    }

    private var allFriendsSection: some View {
        VStack(alignment: .leading, spacing: VinylSpacing.sm) {
            Text("All Friends")
                .font(.headline)
                .foregroundStyle(VinylColors.textPrimary)

            if allFriends.isEmpty {
                EmptyStateView(
                    title: "친구가 아직 없습니다",
                    subtitle: "요청을 보내고 서로 승인하면 연결됩니다.",
                    actionTitle: "친구 요청",
                    action: {}
                )
            } else {
                VStack(spacing: VinylSpacing.sm) {
                    ForEach(allFriends) { friend in
                        FriendNowPlayingRow(friend: friend)
                            .onTapGesture {
                                if let uri = friend.nowPlaying?.rawSpotifyUri, let url = URL(string: uri) {
                                    openURL(url)
                                }
                            }
                            .contextMenu {
                                Button(friend.isPinned ? "핀 해제" : "핀하기") {
                                    Task { await appState.togglePin(friendUid: friend.id) }
                                }
                                Button("Open in Spotify") {
                                    if let uri = friend.nowPlaying?.rawSpotifyUri, let url = URL(string: uri) {
                                        openURL(url)
                                    }
                                }
                                Button("Remove Friend", role: .destructive) {
                                    Task { await appState.removeFriend(friendId: friend.id) }
                                }
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
