import ActivityKit
import Foundation

struct VinylLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        let trackName: String
        let artistName: String
        let albumArtUrl: String
        let timestamp: Date
    }
}
