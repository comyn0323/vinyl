import Foundation

final class AppGroupCache {
    static let shared = AppGroupCache()

    private let defaults: UserDefaults?

    private init() {
        defaults = UserDefaults(suiteName: AppConfig.appGroupId)
    }

    func savePresenceList(_ presences: [Presence]) {
        guard let data = try? JSONEncoder().encode(presences) else { return }
        defaults?.set(data, forKey: "presence.list")
        defaults?.set(Date(), forKey: "presence.updatedAt")
    }

    func loadPresenceList() -> [Presence] {
        guard let data = defaults?.data(forKey: "presence.list") else { return [] }
        return (try? JSONDecoder().decode([Presence].self, from: data)) ?? []
    }
}
