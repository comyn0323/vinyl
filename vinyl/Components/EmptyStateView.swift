import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: VinylSpacing.sm) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(VinylColors.textSecondary)

            Text(title)
                .font(VinylTypography.songTitle)
                .foregroundStyle(VinylColors.textPrimary)

            Text(subtitle)
                .font(VinylTypography.artist)
                .foregroundStyle(VinylColors.textSecondary)
                .multilineTextAlignment(.center)

            if let actionTitle, let action {
                Button(actionTitle) {
                    action()
                }
                .buttonStyle(.bordered)
                .tint(VinylColors.accent)
            }
        }
        .padding(VinylSpacing.lg)
        .frame(maxWidth: .infinity)
        .background(VinylColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: VinylComponents.cardRadius, style: .continuous))
    }
}

#Preview {
    EmptyStateView(
        title: "핀을 꽂아보세요",
        subtitle: "핀한 친구의 음악만 위젯과 Live Activity에 표시됩니다.",
        actionTitle: "친구 요청",
        action: {}
    )
    .padding()
    .background(VinylColors.background)
}
