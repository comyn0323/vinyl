import SwiftUI

struct MainView: View {
    @State private var appState = AppState()
    @State private var friendUidInput: String = ""
    @Environment(\.openURL) private var openURL

    var body: some View {
        @Bindable var bindableState = appState

        NavigationStack {
            List {
                if !appState.isAuthenticated {
                    Section {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("vinyl은 Spotify Now Playing을 실시간으로 공유합니다.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Button("Spotify 로그인") {
                                Task { await appState.signInWithSpotify() }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.vertical, 8)
                    }
                } else {
                    Section {
                        Toggle("공유 활성화", isOn: $bindableState.isSharingEnabled)
                            .onChange(of: appState.isSharingEnabled) { _, newValue in
                                Task { await appState.toggleSharing(isOn: newValue) }
                            }

                        if appState.isSharingEnabled {
                            Text("핀한 친구의 Live Activity/위젯이 업데이트됩니다.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Section("친구 요청 보내기") {
                        HStack {
                            TextField("친구 UID 입력", text: $friendUidInput)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                            Button("요청") {
                                Task { await appState.sendFriendRequest(toUid: friendUidInput) }
                            }
                        }
                    }

                    Section("받은 요청") {
                        if appState.incomingRequests.isEmpty {
                            Text("대기 중인 요청이 없습니다.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(appState.incomingRequests) { request in
                                HStack {
                                    Text(request.fromUid)
                                    Spacer()
                                    Button("수락") {
                                        Task { await appState.respondFriendRequest(requestId: request.id, accept: true) }
                                    }
                                    .buttonStyle(.bordered)
                                    Button("거절") {
                                        Task { await appState.respondFriendRequest(requestId: request.id, accept: false) }
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        }
                    }

                    Section("보낸 요청") {
                        if appState.outgoingRequests.isEmpty {
                            Text("보낸 요청이 없습니다.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(appState.outgoingRequests) { request in
                                Text(request.toUid)
                            }
                        }
                    }

                    Section("Pinned (최대 5명)") {
                        if appState.pinnedPresences.isEmpty {
                            Text("핀한 친구가 없습니다.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(appState.pinnedPresences) { presence in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(presence.trackName.isEmpty ? "재생 중 아님" : presence.trackName)
                                        .font(.headline)
                                    Text(presence.artistName)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .onTapGesture {
                                    if let uri = presence.rawSpotifyUri, let url = URL(string: uri) {
                                        openURL(url)
                                    }
                                }
                                .contextMenu {
                                    Button("핀 해제") {
                                        Task { await appState.togglePin(friendUid: presence.uid) }
                                    }
                                }
                            }
                        }
                    }

                    Section("All Friends (최대 10명)") {
                        if appState.friends.isEmpty {
                            Text("친구가 아직 없습니다.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(appState.friends) { friend in
                                HStack {
                                    Text(friend.displayName)
                                    Spacer()
                                    if appState.pinnedFriendIds.contains(friend.uid) {
                                        Text("핀됨")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .contextMenu {
                                    Button(appState.pinnedFriendIds.contains(friend.uid) ? "핀 해제" : "핀하기") {
                                        Task { await appState.togglePin(friendUid: friend.uid) }
                                    }
                                }
                            }
                        }
                    }
                }

                if let errorMessage = appState.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("vinyl")
            .onAppear {
                appState.configure()
                Task { await appState.refreshAll() }
            }
            .onChange(of: appState.pinnedFriendIds) { _, _ in
                appState.listenToPresence()
            }
        }
    }
}

#Preview {
    MainView()
}
