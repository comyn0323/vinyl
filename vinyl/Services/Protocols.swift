import Foundation

protocol FriendsViewModelProtocol {
    var pinnedFriends: [FriendDisplay] { get }
    var allFriends: [FriendDisplay] { get }
    var incomingRequests: [FriendRequest] { get }
    var outgoingRequests: [FriendRequest] { get }

    func refresh() async
    func sendRequest(to uid: String) async
    func respond(requestId: String, accept: Bool) async
    func togglePin(friendId: String) async
    func removeFriend(friendId: String) async
}

protocol PresenceViewModelProtocol {
    var pinnedFriends: [FriendDisplay] { get }
}
