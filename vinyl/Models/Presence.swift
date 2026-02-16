import Foundation

struct Presence: Codable, Hashable, Identifiable {
    var id: String { uid }
    let uid: String
    let trackId: String
    let trackName: String
    let artistName: String
    let albumArtUrl: String
    let isPlaying: Bool
    let progressMs: Int
    let updatedAt: Date
    let rawSpotifyUri: String?
}
