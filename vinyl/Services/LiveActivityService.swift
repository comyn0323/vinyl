import ActivityKit
import Foundation

@MainActor
final class LiveActivityService {
    static let shared = LiveActivityService()

    private init() {}

    func startIfNeeded(track: Presence) async throws -> Activity<VinylLiveActivityAttributes> {
        let attributes = VinylLiveActivityAttributes()
        let contentState = VinylLiveActivityAttributes.ContentState(
            trackName: track.trackName,
            artistName: track.artistName,
            albumArtUrl: track.albumArtUrl,
            timestamp: Date()
        )

        let content = ActivityContent(state: contentState, staleDate: nil)
        return try Activity.request(attributes: attributes, content: content, pushType: .token)
    }

    func update(activity: Activity<VinylLiveActivityAttributes>, presence: Presence) async {
        let contentState = VinylLiveActivityAttributes.ContentState(
            trackName: presence.trackName,
            artistName: presence.artistName,
            albumArtUrl: presence.albumArtUrl,
            timestamp: Date()
        )

        let content = ActivityContent(state: contentState, staleDate: nil)
        await activity.update(content)
    }

    func stopAll() async {
        for activity in Activity<VinylLiveActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}
