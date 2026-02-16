import SwiftUI

struct OnboardingPhoneView: View {
    @Binding var phoneNumber: String
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: VinylSpacing.lg) {
            Spacer()

            Text("전화번호가 무엇인가요?")
                .font(.title2.weight(.semibold))
                .foregroundStyle(VinylColors.textPrimary)

            TextField("+82 010-0000-0000", text: $phoneNumber)
                .keyboardType(.phonePad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.vertical, 12)
                .padding(.horizontal, VinylSpacing.md)
                .background(VinylColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .foregroundStyle(VinylColors.textPrimary)

            PrimaryButton(title: "계속", isDisabled: phoneNumber.isEmpty) {
                onNext()
            }

            Spacer()
        }
        .padding(VinylSpacing.lg)
        .background(VinylColors.background)
    }
}

#Preview {
    OnboardingPhoneView(phoneNumber: .constant("+82 010-1234-5678"), onNext: {})
}
