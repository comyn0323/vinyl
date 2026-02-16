import Foundation

struct UserProfile: Codable, Hashable {
    let uid: String
    let spotifyUserId: String
    var sharingEnabled: Bool
    var accessToken: String
    var refreshToken: String
    var lastTrackId: String?
    let createdAt: Date
}
