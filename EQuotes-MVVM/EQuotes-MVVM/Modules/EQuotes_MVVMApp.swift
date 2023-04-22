//
//  EQuotes_MVVMApp.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI
import Firebase

@main
struct EQuotes_MVVMApp: App {

    @Environment(\.scenePhase) var scenePhase

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { newValue in
            if scenePhase == .active {
                LearnDefaults.shared.resetLearnDataIfNeeded()
            }

        }

    }
}
