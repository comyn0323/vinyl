//
//  ContentView.swift
//  vinyl
//
//  Created by 윤형준 on 2/16/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false
    @State private var appState = AppState()

    var body: some View {
        Group {
            if onboardingCompleted {
                RootView()
            } else {
                OnboardingFlowView(
                    onSpotifyConnect: {
                        Task { await appState.signInWithSpotify() }
                    },
                    onFinish: {
                        onboardingCompleted = true
                    }
                )
            }
        }
        .onAppear {
            appState.configure()
        }
    }
}

#Preview {
    ContentView()
}
