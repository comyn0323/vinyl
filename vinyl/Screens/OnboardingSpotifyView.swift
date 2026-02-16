import SwiftUI

struct OnboardingSpotifyView: View {
    let onContinue: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(spacing: VinylSpacing.lg) {
            Text("Spotify로 계속하기")
                .font(.title2.weight(.semibold))
                .foregroundStyle(VinylColors.textPrimary)

            Button("Continue with Spotify") {
                onContinue()
            }
            .buttonStyle(.borderedProminent)
            .tint(VinylColors.accent)

            Button("나중에 하기") {
                onSkip()
            }
            .foregroundStyle(VinylColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(VinylColors.background)
    }
}

#Preview {
    OnboardingSpotifyView(onContinue: {}, onSkip: {})
}
