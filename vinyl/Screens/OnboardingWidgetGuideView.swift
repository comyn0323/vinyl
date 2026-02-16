import SwiftUI

struct OnboardingWidgetGuideView: View {
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: VinylSpacing.lg) {
            Spacer()

            TabView {
                widgetPage(title: "마지막으로, 홈 화면에\n위젯을 추가하세요", subtitle: "메뉴에서 위젯 추가를 탭하세요")
                widgetPage(title: "편집 버튼을 탭하세요", subtitle: "홈 화면을 길게 누르면 편집이 열립니다")
                widgetPage(title: "vinyl을 검색하고\n위젯을 추가하세요", subtitle: "위젯 목록에서 vinyl을 찾으세요")
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 360)

            PrimaryButton(title: "위젯을 활성화했습니다") {
                onDone()
            }

            Spacer()
        }
        .padding(VinylSpacing.lg)
        .background(VinylColors.background)
    }

    private func widgetPage(title: String, subtitle: String) -> some View {
        VStack(spacing: VinylSpacing.sm) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(VinylColors.divider, lineWidth: 1)
                .frame(width: 220, height: 300)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(VinylColors.surface)
                        .padding(12)
                )

            Text(title)
                .font(VinylTypography.songTitle)
                .foregroundStyle(VinylColors.textPrimary)
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(VinylTypography.artist)
                .foregroundStyle(VinylColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, VinylSpacing.sm)
    }
}

#Preview {
    OnboardingWidgetGuideView(onDone: {})
}
