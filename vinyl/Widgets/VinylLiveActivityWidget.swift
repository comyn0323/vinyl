import ActivityKit
import SwiftUI
import WidgetKit

struct VinylLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: VinylLiveActivityAttributes.self) { context in
            ZStack {
                VinylColors.background

                HStack(spacing: VinylSpacing.md) {
                    AlbumArtView(url: context.state.albumArtUrl, size: 64)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("친구가 듣는 중")
                            .font(VinylTypography.artist)
                            .foregroundStyle(VinylColors.textSecondary)
                        Text(context.state.trackName)
                            .font(VinylTypography.songTitle)
                            .foregroundStyle(VinylColors.textPrimary)
                            .lineLimit(1)
                        Text(context.state.artistName)
                            .font(VinylTypography.artist)
                            .foregroundStyle(VinylColors.textSecondary)
                            .lineLimit(1)
                    }
                }
                .padding(VinylSpacing.md)
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.trackName)
                        .font(VinylTypography.artist)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.artistName)
                        .font(VinylTypography.artist)
                        .foregroundStyle(VinylColors.textSecondary)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("vinyl")
                        .font(VinylTypography.caption)
                        .foregroundStyle(VinylColors.textSecondary)
                }
            } compactLeading: {
                Text("vinyl")
            } compactTrailing: {
                Text("♪")
            } minimal: {
                Text("♪")
            }
        }
    }
}
