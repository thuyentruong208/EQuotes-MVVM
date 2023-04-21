//
//  LearnListViewModel.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 21/04/2023.
//

import Foundation
import Combine

class LearnListViewModel: ObservableObject {

    @Published var learnQuotesLoadable: Loadable<[QuoteItem]> = .notRequested
    @Published var learnQuotesCount: Int = -1
    @Published var toDateLoadable: Loadable<Date?> = .notRequested

    let dbManager: DatabaseManager
    var cancelBag = Set<AnyCancellable>()

    init(dbManager: DatabaseManager) {
        self.dbManager = dbManager
        addSubscribers()
    }

    func addSubscribers() {
        subscribeLearnQuotes()
        subscribeSetting()
    }

    func subscribeLearnQuotes() {
        learnQuotesLoadable.setIsLoading()

        dbManager.observeList(
            LearnQuote.self,
            in: DB.learnQuotes,
            order: (by: DB.Fields.createdAt, descending: true)
        )
        .map { [weak self] (items) in
            self?.learnQuotesCount = items.count
            return items.compactMap { $0.quoteID }
        }
        .map { Array($0.prefix(10)) }
        .flatMap { [dbManager] (itemIDs) -> AnyPublisher<[QuoteItem], Error> in
            if itemIDs.isEmpty {
                return Just([])
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                return dbManager.observeList(QuoteItem.self, keys: itemIDs, in: DB.quoteItems)
            }

        }
        .mapToLoadble { [weak self] (loadable) in
            self?.learnQuotesLoadable = loadable
        }
        .store(in: &cancelBag)
    }

    func subscribeSetting() {
        dbManager.observeItem(
            [String: Date].self,
            in: DB.userSettings,
            key: DB.KeyID.toDate
        )
        .map { data -> Date? in
            return data[DB.Fields.value]
        }
        .catch(catchSettingsErrorAndReturnNilIfNeeded)
        .mapToLoadble { [weak self] (loadable) in
            self?.toDateLoadable = loadable
        }
        .store(in: &cancelBag)
    }
}

private extension LearnListViewModel {
    func catchSettingsErrorAndReturnNilIfNeeded(error: Error) -> AnyPublisher<Date?, Error> {
        if let error = error as? DecodingError {
            if case .valueNotFound = error {
                return Just(nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }

        return Fail(error: error)
            .eraseToAnyPublisher()
    }
}
