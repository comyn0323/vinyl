import SwiftUI

struct SettingsView: View {
    @State private var appState = AppState()
    @State private var liveActivityEnabled = true

    var body: some View {
        @Bindable var bindableState = appState

        ZStack {
            VinylColors.background
                .ignoresSafeArea()

            List {
                Section("연결된 계정") {
                    if let provider = appState.connectedProvider {
                        HStack {
                            Text(provider.displayName)
                                .foregroundStyle(VinylColors.textPrimary)
                            Spacer()
                            Text("연결됨")
                                .font(VinylTypography.caption)
                                .foregroundStyle(VinylColors.textSecondary)
                        }
                        Button("연결 해제") {
                            appState.disconnectProvider()
                        }
                        .tint(VinylColors.textSecondary)
                    } else {
                        ForEach(MusicProvider.allCases) { provider in
                            HStack {
                                Text(provider.displayName)
                                    .foregroundStyle(VinylColors.textPrimary)
                                Spacer()
                                if provider.isAvailableInMvp {
                                    Button("연결") {
                                        Task { await appState.connectProvider(provider) }
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(VinylColors.accent)
                                } else {
                                    Text("준비 중")
                                        .font(VinylTypography.caption)
                                        .foregroundStyle(VinylColors.textSecondary)
                                }
                            }
                        }
                    }
                }

                Section("Sharing") {
                    Toggle("Sharing ON/OFF", isOn: $bindableState.isSharingEnabled)
                        .onChange(of: appState.isSharingEnabled) { _, newValue in
                            Task { await appState.toggleSharing(isOn: newValue) }
                        }
                }

                Section("Live Activity") {
                    Toggle("Live Activity", isOn: $liveActivityEnabled)
                }

                Section("Manage Friends") {
                    if appState.friends.isEmpty {
                        Text("친구가 없습니다.")
                            .foregroundStyle(VinylColors.textSecondary)
                    } else {
                        ForEach(appState.friends) { friend in
                            HStack {
                                Text(friend.displayName)
                                Spacer()
                                Button("삭제", role: .destructive) {
                                    Task { await appState.removeFriend(friendId: friend.uid) }
                                }
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Settings")
        .onAppear {
            appState.configure()
            Task { await appState.refreshFriends() }
        }
        .listStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
