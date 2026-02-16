import SwiftUI

struct OnboardingIntroView: View {
    var body: some View {
        ZStack {
            VinylColors.background
                .ignoresSafeArea()

            LinearGradient(
                colors: [VinylColors.accent.opacity(0.35), VinylColors.background],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .blur(radius: 30)

            VStack(spacing: VinylSpacing.lg) {
                Text("친구가 지금 듣는 음악을\n말하지 않아도 알 수 있습니다.")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(VinylColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text("vinyl은 음악을 감정의 레이어로 공유합니다.")
                    .font(VinylTypography.artist)
                    .foregroundStyle(VinylColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(VinylSpacing.lg)
        }
    }
}

#Preview {
    OnboardingIntroView()
}
