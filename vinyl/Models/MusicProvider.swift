import Foundation

enum MusicProvider: String, CaseIterable, Identifiable {
    case spotify
    case appleMusic

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .spotify: return "Spotify"
        case .appleMusic: return "Apple Music"
        }
    }

    var isAvailableInMvp: Bool {
        switch self {
        case .spotify: return true
        case .appleMusic: return false
        }
    }
}
