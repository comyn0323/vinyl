import Foundation

struct FriendRequest: Codable, Hashable, Identifiable {
    let id: String
    let fromUid: String
    let toUid: String
    let status: String
    let createdAt: Date
}
