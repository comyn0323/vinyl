import Foundation

struct Friend: Codable, Hashable, Identifiable {
    var id: String { uid }
    let uid: String
    let displayName: String
    let photoUrl: String?
}
