//
//  MenuView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 22/04/2023.
//

import SwiftUI

struct MenuView: View {
    @AppStorage(LearnDefaults.Keys.learnMode) private var learnMode = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 25) {
                logoAndLearnMode
                Divider()
                guideSection
                Spacer()
            }
            .padding()
            .frame(maxWidth: getRect().width * 0.55 - 20)

            Spacer()
        }
        .background(Color.secondTheme.background)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 50)
    }
}

private extension MenuView {
    var logoAndLearnMode: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image("image")
                .resizable()
                .frame(width: 120, height: 120)
                .scaledToFit()

            HStack {
                Text("Learn Mode")
                    .font(.title3)
                    .foregroundColor(.secondTheme.accent)

                Spacer()

                Toggle("", isOn: $learnMode)
                    .tint(.secondTheme.accent)
            }
        }
    }

    var guideSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Guide")
                .font(.title2)
                .foregroundColor(.secondTheme.accent)
                .fontWeight(.bold)

            Text("in LearnMode, swipe right to mark as learned")
                .font(.callout)
                .foregroundColor(.secondTheme.accent.opacity(0.8))

        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
