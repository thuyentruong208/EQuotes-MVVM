//
//  MainView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI

struct MainView: View {
    @State var showMenu = false
    @AppStorage(LearnDefaults.Keys.learnMode) private var learnMode = true
    @AppStorage(LearnDefaults.Keys.todayLearnedCount) private var todayLearnedCount = 0

    var body: some View {
        ZStack {
            // backgroundView
            Color.theme.backgroundView
                .ignoresSafeArea()

            // content
            VStack(spacing: 4) {
                headerView
                Divider().background(Color.theme.accent)

                Spacer(minLength: 0)

                if learnMode {
                    LearnListView()

                } else {
                    QuoteListView()
                }

            }
            .padding()
        }
        .ignoresSafeArea(.all, edges: .bottom)

    }
}

private extension MainView {

    var headerView: some View {
        HStack {
            AnimatedMenuButton(showMenu: $showMenu)
                .onTapGesture {
                    withAnimation {
                        showMenu.toggle()
                    }
                }

            Text(learnMode ? "Learn" : "Quotes")
                .foregroundColor(.theme.accent)
                .font(.title)

            Spacer()

            trailingHeaderView
        }
    }

    var trailingHeaderView: some View {
        HStack(spacing: 16) {
            learnCountView

            if !learnMode {
                Button {

                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.theme.accent)
                }
            }
        }
    }

    var learnCountView: some View {
        Text("\(todayLearnedCount)")
            .foregroundColor(.secondTheme.accent)
            .font(.subheadline)
            .padding(6)
            .background(Circle().fill(Color.secondTheme.background))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
