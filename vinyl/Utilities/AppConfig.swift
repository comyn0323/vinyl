import Foundation

enum AppConfig {
    static let bundleId = "com.vinyl.app"
    static let firebaseProjectId = "vinyl-9538c"

    // TODO: Fill these from your Spotify developer settings.
    static let spotifyClientId = "8a4875c384d947ad96968ba00afb0078"
    // Re-typed to avoid hidden characters.
    static let spotifyRedirectUri = "vinyl://oauth-callback"

    // Cloud Functions base URL (1st gen style).
    static let functionsBaseUrl = "https://us-central1-vinyl-9538c.cloudfunctions.net"

    // Gen2 HTTP function URL (from deploy logs).
    static let oauthCallbackUrl = "https://oauthcallback-jck3f4r24a-uc.a.run.app"

    // App Group for widget/Live Activity cache
    static let appGroupId = "group.com.vinyl.app"
}
