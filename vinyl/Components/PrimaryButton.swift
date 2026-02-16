import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .tint(VinylColors.accent)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

#Preview {
    VStack(spacing: 12) {
        PrimaryButton(title: "계속", action: {})
        PrimaryButton(title: "계속", isDisabled: true, action: {})
    }
    .padding()
    .background(VinylColors.background)
}
