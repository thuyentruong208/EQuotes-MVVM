//
//  AnimatedMenuButton.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import SwiftUI

struct AnimatedMenuButton: View {
    @Binding var showMenu: Bool

    var body: some View {
        VStack(spacing: 5){

            Capsule()
                .fill(showMenu ? Color.secondTheme.accent : Color.theme.accent)
                .frame(width: 30, height: 3)
            // Rotating...
                .rotationEffect(.init(degrees: showMenu ? -50 : 0))
                .offset(x: showMenu ? 2 : 0, y: showMenu ? 9 : 0)

            VStack(spacing: 5){

                Capsule()
                    .fill(showMenu ? Color.secondTheme.accent : Color.theme.accent)
                    .frame(width: 30, height: 3)
                // Moving Up when clicked...
                Capsule()
                    .fill(showMenu ? Color.secondTheme.accent : Color.theme.accent)
                    .frame(width: 30, height: 3)
                    .offset(y: showMenu ? -8 : 0)
            }
            .rotationEffect(.init(degrees: showMenu ? 50 : 0))
        }
        .contentShape(Rectangle())
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AnimatedMenuButton(showMenu: .constant(false))
                .frame(width: 100, height: 100)
                .background(Color.theme.backgroundView)
                .previewLayout(.sizeThatFits)

            AnimatedMenuButton(showMenu: .constant(true))
                .background(Color.secondTheme.background)
                .previewLayout(.sizeThatFits)
        }
    }
}
