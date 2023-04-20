//
//  Color.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = Theme()
    static let secondTheme = SecondTheme()

}

struct Theme {
    let backgroundView = GradientView(gradientModel: gradients[1])
    let accent = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))


}

struct SecondTheme {
    let background = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    let accent = Color(#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1))
}
