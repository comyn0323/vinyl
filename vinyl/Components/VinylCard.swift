import SwiftUI

struct VinylCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(VinylSpacing.md)
            .background(VinylColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: VinylComponents.cardRadius, style: .continuous))
            .shadow(color: VinylComponents.shadowColor, radius: 10, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: VinylComponents.cardRadius, style: .continuous)
                    .stroke(VinylColors.divider, lineWidth: 1)
            )
    }
}

#Preview {
    VinylCard {
        VStack(alignment: .leading, spacing: VinylSpacing.sm) {
            Text("Sample Card")
                .font(VinylTypography.friendName)
                .foregroundStyle(VinylColors.textPrimary)
            Text("Subtext")
                .font(VinylTypography.artist)
                .foregroundStyle(VinylColors.textSecondary)
        }
    }
    .padding()
    .background(VinylColors.background)
}
