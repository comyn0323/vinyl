import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem { Label("Home", systemImage: "house") }

            NavigationStack {
                FriendsRequestsView()
            }
            .tabItem { Label("Friends", systemImage: "person.2") }

            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .tint(VinylColors.accent)
    }
}

#Preview {
    RootView()
}
