//
//  QuoteListViewModel.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import Foundation
import Combine

class QuoteListViewModel: ObservableObject {

    @Published var quotesLoadable: Loadable<[QuoteItem]> = .notRequested

    let dbManager: DatabaseManager
    var cancelBag = Set<AnyCancellable>()

    init(dbManager: DatabaseManager) {
        self.dbManager = dbManager
        addSubscribers()
    }

    func addSubscribers() {
        quotesLoadable.setIsLoading()

        dbManager.observeList(
            QuoteItem.self,
            in: DB.quoteItems,
            order: (by: DB.Fields.createdAt, descending: true)
        )
        .mapToLoadble { [weak self] (loadable) in
            self?.quotesLoadable = loadable
        }
        .store(in: &cancelBag)
    }


}
