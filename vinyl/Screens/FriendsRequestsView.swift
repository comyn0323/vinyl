import SwiftUI

struct FriendsRequestsView: View {
    @State private var appState = AppState()
    @State private var friendUidInput: String = ""

    var body: some View {
        ZStack {
            VinylColors.background
                .ignoresSafeArea()

            List {
                Section("친구 요청 보내기") {
                    HStack {
                        TextField("친구 UID 입력", text: $friendUidInput)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        Button("요청") {
                            Task { await appState.sendFriendRequest(toUid: friendUidInput) }
                        }
                        .buttonStyle(.bordered)
                        .tint(VinylColors.accent)
                    }
                }

                Section("받은 요청") {
                    if appState.incomingRequests.isEmpty {
                        Text("대기 중인 요청이 없습니다.")
                            .foregroundStyle(VinylColors.textSecondary)
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
                            .foregroundStyle(VinylColors.textSecondary)
                    } else {
                        ForEach(appState.outgoingRequests) { request in
                            Text(request.toUid)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Requests")
        .onAppear {
            appState.configure()
            Task { await appState.refreshRequests() }
        }
    }
}

#Preview {
    NavigationStack {
        FriendsRequestsView()
    }
}
