//
//  MainView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI

struct MainView: View {
    @State var showMenu = false
    @AppStorage("learnMode") private var learnMode = false

    var body: some View {
        ZStack {
            // backgroundView
            Color.theme.backgroundView
                .ignoresSafeArea()

            // content
            VStack {
                headerView
                Divider().background(Color.theme.accent)
                bottomHeaderView

                Spacer(minLength: 20)

                if learnMode {

                } else {
                    QuoteListView()
                }

            }
            .padding()
        }
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
        Text("30")
            .foregroundColor(.secondTheme.accent)
            .font(.subheadline)
            .padding(6)
            .background(Circle().fill(Color.secondTheme.background))
    }

    var bottomHeaderView: some View {
        VStack {
            if learnMode {
                Text("30/20/2023 10:30 PM")
                    .font(.caption)
                    .foregroundColor(.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }

    }

}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
