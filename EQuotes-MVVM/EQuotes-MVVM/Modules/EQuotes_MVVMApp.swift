//
//  EQuotes_MVVMApp.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct EQuotes_MVVMApp: App {

    init() {
        FirebaseApp.configure()

        Auth.auth().signInAnonymously() { _, error in
            if let error = error {
                logger.error("Error: \(error)")
                return
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
            #if os(macOS)
                .frame(maxWidth: 700, maxHeight: .infinity)
            #endif

        }
        .windowResizabilityContentSize()
    }
}
