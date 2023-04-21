//
//  CardStyleViewModifier.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 21/04/2023.
//

import SwiftUI

struct CardStyleViewModifier: ViewModifier {

    let backgroundColor: Color
    let accent: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20).fill(backgroundColor)
                .shadow(color: accent.opacity(0.35), radius: 15, x: 0, y: 0)
            )
            .foregroundColor(accent)
            .font(.system(size: 18))
            .transition(.scale)
    }
}

