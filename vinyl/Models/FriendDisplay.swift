import Foundation

struct FriendDisplay: Hashable, Identifiable {
    let id: String
    let name: String
    let isPinned: Bool
    let nowPlaying: Track?
}
