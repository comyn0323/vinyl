import SwiftUI

struct AlbumArtView: View {
    let url: String
    let size: CGFloat

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [VinylColors.albumPlaceholderStart, VinylColors.albumPlaceholderEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .stroke(VinylColors.textSecondary.opacity(0.3), lineWidth: 1)
                .padding(size * 0.22)

            AsyncImage(url: URL(string: url)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                EmptyView()
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: VinylComponents.albumRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: VinylComponents.albumRadius, style: .continuous)
                .stroke(VinylColors.divider, lineWidth: 1)
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        AlbumArtView(url: "", size: 80)
        AlbumArtView(url: "https://i.scdn.co/image/ab67616d0000b2730f9a30b821acfc4f3b6c2e5d", size: 120)
    }
    .padding()
    .background(VinylColors.background)
}
