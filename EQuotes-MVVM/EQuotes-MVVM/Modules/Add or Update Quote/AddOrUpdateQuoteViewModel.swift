//
//  AddOrUpdateViewModel.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 22/04/2023.
//

import Foundation
import SwiftUI
import Combine

class AddOrUpateQuoteViewModel: ObservableObject {

    let dbManager: DatabaseManager
    var cancelBag = Set<AnyCancellable>()

    @Published var addQuoteStatus: Loadable<Bool> = .notRequested
    @Published var updateQuoteStatus: Loadable<Bool> = .notRequested

    init(dbManager: DatabaseManager) {
        self.dbManager = dbManager
    }

    func addQuote(item: QuoteItem) {
        dbManager.create(item, in: DB.quoteItems)
            .map { true }
            .mapToLoadble { [weak self] addQuoteStatus in
                self?.addQuoteStatus = addQuoteStatus
            }
            .store(in: &cancelBag)
    }

    func updateQuote(item: QuoteItem) {
        guard let id = item.id else { return }

        dbManager.update(key: id, item, in: DB.quoteItems)
            .map { true }
            .mapToLoadble { [weak self] updateQuoteStatus in
                self?.updateQuoteStatus = updateQuoteStatus
            }
            .store(in: &cancelBag)
    }

}
