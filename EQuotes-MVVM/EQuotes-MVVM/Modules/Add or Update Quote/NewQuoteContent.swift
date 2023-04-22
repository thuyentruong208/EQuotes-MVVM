//
//  NewQuoteContent.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 22/04/2023.
//

import Foundation

class NewQuoteContent: ObservableObject {

    var id: String?
    @Published var enContent: String = ""
    @Published var viContent: String = ""
    @Published var hintContent: String = ""
    @Published var hintImages: String = ""

    convenience init(quoteItem: QuoteItem?) {
        self.init()
        self.id = quoteItem?.id
        self.enContent = quoteItem?.en ?? ""
        self.viContent = quoteItem?.vi ?? ""
        self.hintContent = quoteItem?.ask ?? ""
        self.hintImages = quoteItem?.images ?? ""
    }

    func toQuoteItem() -> QuoteItem {
        return QuoteItem(
            id: id,
            en: enContent,
            vi: viContent.isEmpty ? nil : viContent,
            ask: hintContent,
            images: hintImages
        )
    }

    func clear() {
        id = nil
        enContent = ""
        viContent = ""
        hintContent = ""
        hintImages = ""
    }
}
