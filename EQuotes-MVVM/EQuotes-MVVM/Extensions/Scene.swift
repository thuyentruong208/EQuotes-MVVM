//
//  Scene.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 23/04/2023.
//

import SwiftUI

extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        #if macOS
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
        #else
        return self
        #endif

    }
}
