import SwiftUI

struct StatusBadge: View {
    let isPlaying: Bool

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(isPlaying ? VinylColors.accent : VinylColors.textSecondary)
                .frame(width: 6, height: 6)
            Text(isPlaying ? "Listening" : "Paused")
                .font(VinylTypography.caption)
                .foregroundStyle(VinylColors.textSecondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(VinylColors.surface)
        .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: 12) {
        StatusBadge(isPlaying: true)
        StatusBadge(isPlaying: false)
    }
    .padding()
    .background(VinylColors.background)
}
