import AuthenticationServices
import Foundation

final class SpotifyAuthService: NSObject {
    struct AuthResult: Decodable {
        let firebaseCustomToken: String
        let spotifyUserId: String
    }

    private let backend = BackendClient()
    private var session: ASWebAuthenticationSession?

    @MainActor
    func authorize() async throws -> AuthResult {
        let state = UUID().uuidString
        let scope = "user-read-currently-playing user-read-playback-state"

        var components = URLComponents(string: "https://accounts.spotify.com/authorize")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: AppConfig.spotifyClientId),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: AppConfig.spotifyRedirectUri),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "state", value: state)
        ]

        guard let authUrl = components?.url else {
            throw URLError(.badURL)
        }

        let callbackUrl: URL = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
            session = ASWebAuthenticationSession(url: authUrl, callbackURLScheme: "vinyl") { url, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let url else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                    return
                }
                continuation.resume(returning: url)
            }
            session?.presentationContextProvider = self
            session?.prefersEphemeralWebBrowserSession = true
            session?.start()
        }

        guard let code = URLComponents(url: callbackUrl, resolvingAgainstBaseURL: false)?
            .queryItems?.first(where: { $0.name == "code" })?.value else {
            throw URLError(.cannotParseResponse)
        }

        let result: AuthResult = try await backend.postJson(AppConfig.oauthCallbackUrl, body: [
            "code": code,
            "redirectUri": AppConfig.spotifyRedirectUri
        ])

        return result
    }
}

extension SpotifyAuthService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        WindowProvider.presentationAnchor()
    }
}
