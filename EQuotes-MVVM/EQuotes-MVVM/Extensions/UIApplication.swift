//
//  UIApplication.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 22/04/2023.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
