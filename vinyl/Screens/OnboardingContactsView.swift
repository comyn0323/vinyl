import SwiftUI

struct OnboardingContactsView: View {
    let onSkip: () -> Void
    let onShare: () -> Void

    var body: some View {
        VStack(spacing: VinylSpacing.lg) {
            Spacer()

            Text("친구를 찾으세요!")
                .font(.title2.weight(.semibold))
                .foregroundStyle(VinylColors.textPrimary)

            Text("친구를 찾을 수 있도록 연락처 접근 권한이 필요합니다.")
                .font(VinylTypography.artist)
                .foregroundStyle(VinylColors.textSecondary)
                .multilineTextAlignment(.center)

            PrimaryButton(title: "모든 연락처 공유") {
                onShare()
            }

            Button("다음에 하기") {
                onSkip()
            }
            .foregroundStyle(VinylColors.textSecondary)

            Spacer()
        }
        .padding(VinylSpacing.lg)
        .background(VinylColors.background)
    }
}

#Preview {
    OnboardingContactsView(onSkip: {}, onShare: {})
}
