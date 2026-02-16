import SwiftUI

struct OnboardingFlowView: View {
    private enum Step: Int, CaseIterable {
        case intro
        case spotify
        case phone
        case code
        case name
        case contacts
        case pin
        case widget
    }

    @State private var step: Step = .intro
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var displayName: String = ""

    let onSpotifyConnect: () -> Void
    let onFinish: () -> Void

    var body: some View {
        ZStack {
            VinylColors.background
                .ignoresSafeArea()

            switch step {
            case .intro:
                OnboardingIntroView()
                    .overlay(alignment: .bottom) {
                        PrimaryButton(title: "다음") {
                            step = .spotify
                        }
                        .padding(VinylSpacing.lg)
                    }
            case .spotify:
                OnboardingSpotifyView(onContinue: {
                    onSpotifyConnect()
                    step = .contacts
                }, onSkip: {
                    step = .contacts
                })
            case .phone:
                OnboardingPhoneView(phoneNumber: $phoneNumber) {
                    step = .code
                }
            case .code:
                OnboardingCodeView(code: $verificationCode) {
                    step = .name
                }
            case .name:
                OnboardingNameView(name: $displayName) {
                    step = .contacts
                }
            case .contacts:
                OnboardingContactsView(onSkip: {
                    step = .pin
                }, onShare: {
                    step = .pin
                })
            case .pin:
                OnboardingPinGuideView()
                    .overlay(alignment: .bottom) {
                        PrimaryButton(title: "다음") {
                            step = .widget
                        }
                        .padding(VinylSpacing.lg)
                    }
            case .widget:
                OnboardingWidgetGuideView {
                    onFinish()
                }
            }
        }
    }
}

#Preview {
    OnboardingFlowView(onSpotifyConnect: {}, onFinish: {})
}
