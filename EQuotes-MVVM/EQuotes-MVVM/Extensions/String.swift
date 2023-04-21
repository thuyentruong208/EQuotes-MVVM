//
//  String.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import Foundation

extension String {
    
    func markdownToAttributed() -> AttributedString {
        do {
            return try AttributedString(markdown: self) /// convert to AttributedString
        } catch {
            return AttributedString("Error parsing markdown: \(error)")
        }
    }
}
