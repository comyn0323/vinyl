import SwiftUI

struct FriendNowPlayingRow: View {
    let friend: FriendDisplay

    var body: some View {
        VinylCard {
            HStack(spacing: VinylSpacing.md) {
                AlbumArtView(url: friend.nowPlaying?.albumArtUrl ?? "", size: 64)

                VStack(alignment: .leading, spacing: 6) {
                    Text(friend.name)
                        .font(VinylTypography.friendName)
                        .foregroundStyle(VinylColors.textPrimary)
                        .lineLimit(1)

                    Text(friend.nowPlaying?.title ?? "재생 중 아님")
                        .font(VinylTypography.songTitle)
                        .foregroundStyle(VinylColors.textPrimary)
                        .lineLimit(1)

                    Text(friend.nowPlaying?.artist ?? "")
                        .font(VinylTypography.artist)
                        .foregroundStyle(VinylColors.textSecondary)
                        .lineLimit(1)
                }

                Spacer()

                StatusBadge(isPlaying: friend.nowPlaying?.isPlaying ?? false)
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        FriendNowPlayingRow(friend: FriendDisplay(
            id: "1",
            name: "민지",
            isPinned: true,
            nowPlaying: Track(title: "Love Dive", artist: "IVE", albumArtUrl: "", isPlaying: true, rawSpotifyUri: nil)
        ))
        FriendNowPlayingRow(friend: FriendDisplay(
            id: "2",
            name: "준호",
            isPinned: false,
            nowPlaying: nil
        ))
    }
    .padding()
    .background(VinylColors.background)
}
