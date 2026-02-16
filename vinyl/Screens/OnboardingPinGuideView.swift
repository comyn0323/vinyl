import SwiftUI

struct OnboardingPinGuideView: View {
    var body: some View {
        VStack(spacing: VinylSpacing.lg) {
            Text("핀 설정")
                .font(.title2.weight(.semibold))
                .foregroundStyle(VinylColors.textPrimary)

            Text("핀한 친구만 위젯과\nLive Activity에 표시됩니다.\n최대 5명")
                .font(VinylTypography.artist)
                .foregroundStyle(VinylColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(VinylColors.background)
    }
}

#Preview {
    OnboardingPinGuideView()
}
