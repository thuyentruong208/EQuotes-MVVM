//
//  ContentView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        MainView()
            .onChange(of: scenePhase) { newValue in
                if scenePhase == .active {
                    LearnDefaults.shared.resetLearnDataIfNeeded()
                }

            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
