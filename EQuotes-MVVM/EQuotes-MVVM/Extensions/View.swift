//
//  View.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 22/04/2023.
//

import SwiftUI

extension View{

    func getRect() -> CGSize {
#if os(watchOS)
        return WKInterfaceDevice.current().screenBounds.size
#elseif os(iOS)
        return UIScreen.main.bounds.size
#elseif os(macOS)
        let screenSize = NSScreen.main?.visibleFrame.size ?? CGSize.zero
        return CGSize(width: 700, height: screenSize.height)
#endif
    }
}
