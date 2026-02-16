import SwiftUI

struct PinnedFriendChip: View {
    let friend: FriendDisplay
    var isSelected: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: VinylSpacing.sm) {
            AlbumArtView(url: friend.nowPlaying?.albumArtUrl ?? "", size: 84)

            Text(friend.name)
                .font(VinylTypography.songTitle)
                .foregroundStyle(VinylColors.textPrimary)
                .lineLimit(1)

            Text(friend.nowPlaying?.isPlaying == true ? "Listening" : "Paused")
                .font(VinylTypography.artist)
                .foregroundStyle(VinylColors.textSecondary)
                .lineLimit(1)
        }
        .padding(VinylSpacing.sm)
        .background(VinylColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: VinylComponents.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: VinylComponents.cardRadius, style: .continuous)
                .stroke(isSelected ? VinylColors.accent : VinylColors.divider, lineWidth: 1)
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    HStack(spacing: 16) {
        PinnedFriendChip(friend: FriendDisplay(
            id: "1",
            name: "소연",
            isPinned: true,
            nowPlaying: Track(title: "Magnetic", artist: "ILLIT", albumArtUrl: "", isPlaying: true, rawSpotifyUri: nil)
        ))
        PinnedFriendChip(friend: FriendDisplay(
            id: "2",
            name: "태준",
            isPinned: false,
            nowPlaying: Track(title: "", artist: "", albumArtUrl: "", isPlaying: false, rawSpotifyUri: nil)
        ), isSelected: true)
    }
    .padding()
    .background(VinylColors.background)
}
