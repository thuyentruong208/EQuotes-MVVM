//
//  ContentView.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI

struct ContentView: View {

    @State var showMenu = false

    var body: some View {
        ZStack {
            Color.secondTheme.background

            ScrollView(getRect().height < 750 ? .vertical : .init(), showsIndicators: false) {
                MenuView()
            }

            ZStack {
                blurMainView
                    .opacity(0.5)
                    .padding(.vertical, 18)
                    .offset(x: showMenu ? -25 : 0)

                blurMainView
                    .padding(.vertical, 60)
                    .opacity(0.4)
                    .offset(x: showMenu ? -50 : 0)

                MainView()
                    .cornerRadius(showMenu ? 20 : 0)

            }
            .scaleEffect(showMenu ? 0.84 : 1)
            .offset(x: showMenu ? getRect().width * 0.55 : 0)

        }
        .ignoresSafeArea(.all)
        .overlay(alignment: .topLeading) {
            AnimatedMenuButton(showMenu: $showMenu)
                .onTapGesture {
                    withAnimation {
                        showMenu.toggle()
                    }
                }
                .padding(.leading, 10)
                .padding(.top, 6)
        }
    }
}

private extension ContentView {

    var blurMainView: some View {
        Color.theme.backgroundView
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
            .padding(.vertical,30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
