import SwiftUI

struct OnboardingCodeView: View {
    @Binding var code: String
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: VinylSpacing.lg) {
            Spacer()

            Text("전화번호를 인증하세요")
                .font(.title2.weight(.semibold))
                .foregroundStyle(VinylColors.textPrimary)

            Text("6자리 코드를 입력하세요")
                .font(VinylTypography.artist)
                .foregroundStyle(VinylColors.textSecondary)

            TextField("123456", text: $code)
                .keyboardType(.numberPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.vertical, 12)
                .padding(.horizontal, VinylSpacing.md)
                .background(VinylColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .foregroundStyle(VinylColors.textPrimary)

            PrimaryButton(title: "계속", isDisabled: code.count < 6) {
                onNext()
            }

            Spacer()
        }
        .padding(VinylSpacing.lg)
        .background(VinylColors.background)
    }
}

#Preview {
    OnboardingCodeView(code: .constant("123456"), onNext: {})
}
