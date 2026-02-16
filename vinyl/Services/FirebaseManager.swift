import Foundation

#if canImport(FirebaseCore)
import FirebaseCore
#endif

#if canImport(FirebaseAuth)
import FirebaseAuth
#endif

@MainActor
final class FirebaseManager {
    static let shared = FirebaseManager()

    private init() {}

    func configureIfNeeded() {
        #if canImport(FirebaseCore)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        #endif
    }

    func signInWithCustomToken(_ token: String) async throws {
        #if canImport(FirebaseAuth)
        _ = try await Auth.auth().signIn(withCustomToken: token)
        #else
        throw NSError(domain: "FirebaseAuthMissing", code: 1)
        #endif
    }

    var currentUserId: String? {
        #if canImport(FirebaseAuth)
        return Auth.auth().currentUser?.uid
        #else
        return nil
        #endif
    }
}
