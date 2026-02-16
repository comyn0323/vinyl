import SwiftUI

struct OnboardingNameView: View {
    @Binding var name: String
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: VinylSpacing.lg) {
            Spacer()

            Text("사용자 이름 선택")
                .font(.title2.weight(.semibold))
                .foregroundStyle(VinylColors.textPrimary)

            TextField("이름", text: $name)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .padding(.vertical, 12)
                .padding(.horizontal, VinylSpacing.md)
                .background(VinylColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .foregroundStyle(VinylColors.textPrimary)

            PrimaryButton(title: "계속", isDisabled: name.isEmpty) {
                onNext()
            }

            Spacer()
        }
        .padding(VinylSpacing.lg)
        .background(VinylColors.background)
    }
}

#Preview {
    OnboardingNameView(name: .constant("comyn"), onNext: {})
}
