import UIKit

enum WindowProvider {
    static func keyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
    }

    static func presentationAnchor() -> UIWindow {
        if let window = keyWindow() {
            return window
        }

        if let scene = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first {
            return UIWindow(windowScene: scene)
        }

        return UIWindow(frame: .zero)
    }
}
