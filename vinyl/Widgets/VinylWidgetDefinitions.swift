import SwiftUI
import WidgetKit

struct VinylPresenceEntry: TimelineEntry {
    let date: Date
    let presences: [Presence]
}

struct VinylPresenceProvider: TimelineProvider {
    func placeholder(in context: Context) -> VinylPresenceEntry {
        VinylPresenceEntry(date: Date(), presences: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (VinylPresenceEntry) -> Void) {
        let presences = AppGroupCache.shared.loadPresenceList()
        completion(VinylPresenceEntry(date: Date(), presences: presences))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VinylPresenceEntry>) -> Void) {
        let presences = AppGroupCache.shared.loadPresenceList()
        let entry = VinylPresenceEntry(date: Date(), presences: presences)
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
        completion(timeline)
    }
}

struct VinylSmallWidgetView: View {
    let entry: VinylPresenceEntry

    var body: some View {
        ZStack {
            VinylColors.background

            if let first = entry.presences.first {
                VStack(alignment: .leading, spacing: VinylSpacing.sm) {
                    AlbumArtView(url: first.albumArtUrl, size: 96)
                    Text(first.uid)
                        .font(VinylTypography.songTitle)
                        .foregroundStyle(VinylColors.textPrimary)
                        .lineLimit(1)
                }
                .padding(VinylSpacing.sm)
            } else {
                Text("No pinned friends")
                    .font(VinylTypography.artist)
                    .foregroundStyle(VinylColors.textSecondary)
            }
        }
    }
}

struct VinylMediumWidgetView: View {
    let entry: VinylPresenceEntry

    var body: some View {
        ZStack {
            VinylColors.background

            let items = Array(entry.presences.prefix(4))
            if items.isEmpty {
                Text("Pin friends to see updates")
                    .font(VinylTypography.artist)
                    .foregroundStyle(VinylColors.textSecondary)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: VinylSpacing.sm) {
                    ForEach(items) { presence in
                        VStack(alignment: .leading, spacing: 6) {
                            AlbumArtView(url: presence.albumArtUrl, size: 56)
                            Text(presence.uid)
                                .font(VinylTypography.artist)
                                .foregroundStyle(VinylColors.textPrimary)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(VinylSpacing.sm)
            }
        }
    }
}

struct VinylSmallWidget: Widget {
    let kind: String = "vinyl.small"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VinylPresenceProvider()) { entry in
            VinylSmallWidgetView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("vinyl")
        .description("핀한 친구의 최신 음악")
    }
}

struct VinylMediumWidget: Widget {
    let kind: String = "vinyl.medium"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VinylPresenceProvider()) { entry in
            VinylMediumWidgetView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("vinyl")
        .description("핀한 친구의 음악을 한 번에")
    }
}
