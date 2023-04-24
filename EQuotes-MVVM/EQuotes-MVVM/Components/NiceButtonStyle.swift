//
//  NiceButtonStyle.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 24/04/2023.
//

import SwiftUI

struct NiceButtonStyle: ButtonStyle {
    var font: Font
    var foregroundColor: Color
    var backgroundColor: Color
    var pressedColor: Color
    var padding: EdgeInsets

    init(font: Font = .headline,
         foregroundColor: Color,
         backgroundColor: Color,
         pressedColor: Color? = nil,
         padding: EdgeInsets = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    ) {
        self.font = font
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.pressedColor = pressedColor ?? foregroundColor
        self.padding = padding
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(font)
            .padding(padding)
            .foregroundColor(foregroundColor)
            .background(configuration.isPressed ? pressedColor : backgroundColor)
            .cornerRadius(5)
    }
}
