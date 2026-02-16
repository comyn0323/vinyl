import Foundation

struct Track: Hashable, Codable {
    let title: String
    let artist: String
    let albumArtUrl: String
    let isPlaying: Bool
    let rawSpotifyUri: String?
}
