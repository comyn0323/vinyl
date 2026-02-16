import SwiftUI

struct OnboardingFriendGuideView: View {
    var body: some View {
        VStack(spacing: VinylSpacing.lg) {
            Text("친구 초대")
                .font(.title2.weight(.semibold))
                .foregroundStyle(VinylColors.textPrimary)

            Text("친구 요청을 보내고\n서로 승인하면 연결됩니다.")
                .font(VinylTypography.artist)
                .foregroundStyle(VinylColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(VinylColors.background)
    }
}

#Preview {
    OnboardingFriendGuideView()
}
