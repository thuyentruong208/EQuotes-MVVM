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

    private let dbManager: DatabaseManager
    private let englishAPI: EnglishAPI
    private var cancelBag = Set<AnyCancellable>()
    private let numberOfNewQuotesPerDay = 5

    init(
        dbManager: DatabaseManager = RealDatabaseManager.shared,
        englishAPI: EnglishAPI = RealEnglishAPI()
    ) {
        self.dbManager = dbManager
        self.englishAPI = englishAPI
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
            order: [
                (by: DB.Fields.createdAt, descending: true),
                (by: DB.Fields.quoteID, descending: true)
            ]
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

    func markAsDone(item: QuoteItem) {
        dbManager.delete(DB.Fields.quoteID, isEqualTo: item.rID, in: DB.learnQuotes)
            .sink(receiveCompletion: { (completion) in
                switch (completion) {
                case .failure(let error):
                    logger.error("Error: \(error)")
                case .finished:
                    LearnDefaults.shared.todayLearnedCount += 1
                    LearnDefaults.shared.learnedAt = Date()

                    logger.info("[Done] doneLearnQuote \(item.rID)")
                }

            }, receiveValue: { _ in })
            .store(in: &cancelBag)

    }

    func resetLearnDataIfNeeded() {
        if !Calendar.current.isDateInToday(LearnDefaults.shared.learnedAt) {
            LearnDefaults.shared.learnedAt = Date()
            LearnDefaults.shared.todayLearnedCount = 0
        }
    }

    func autoFillHintIfNeeded(item: QuoteItem) async {
        guard item.ask == "" || item.ask == nil else {
            return
        }

        do {
            let translatedText = try await englishAPI.translate(item.en)
            let newQuoteItem = item.copyWith(ask: translatedText)
            dbManager.update(key: item.rID, newQuoteItem, in: DB.quoteItems)
                .generalCompletionHandler()
                .store(in: &cancelBag)
        } catch {
            logger.error("Error: \(error.localizedDescription)")
        }

    }

    func generateLearnQuotes(force: Bool = false) {
        guard case let .loaded(toDate) = toDateLoadable else {
            return
        }

        let (numberOfNewQuotes, newToDate) = calNumberOfNewQuotes(generatedDate: toDate, force: force)
        guard numberOfNewQuotes > 0 else {
            return
        }

        // create learnQuote in dbManager
        dbManager.observeList(QuoteItem.self, in: DB.quoteItems, order: [])
            .map { ($0.map(\.rID), numberOfNewQuotes) }
            .map(generateNewQuoteIDs)
            .map { ($0, newToDate) }
            .flatMap(createLearnQuote)
            .map { [weak self] in
                self?.toDateLoadable = .loaded(newToDate)
            }
            .generalCompletionHandler()
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

    // calNumberOfNewQuotes
    // if force is false:
    //      => numberOfNewQuotes = 5 * missing generated days
    //      => numberOfNewQuotes = 0 if already generated enough
    // if force is true
    //      => numberOfNewQuotes = 5 * missing generated days
    //      => numberOfNewQuotes = 5 if already generated enough and generate more
    func calNumberOfNewQuotes(generatedDate: Date?, force: Bool) -> (Int, Date) {
        var numberOfNewQuotes = numberOfNewQuotesPerDay // default number of generated LearnQuote
        if let generatedDate = generatedDate {
            var diff = Calendar.current.numberOfDaysBetween(generatedDate, and: Date())
            diff = diff <= 0 ? 0 : diff
            numberOfNewQuotes = diff * 5
        }

        var newToDate = Date()
        if force && numberOfNewQuotes == 0 {
            newToDate = generatedDate?.addingTimeInterval(24 * 3600) ?? Date()
            numberOfNewQuotes = 5
        }

        return (numberOfNewQuotes, newToDate)
    }

    func generateNewQuoteIDs(quoteIDs: [String], numberOfNewQuotes: Int) -> [String] {
        var newQuoteIDs = [String]()
        var numberOfNewQuotes = numberOfNewQuotes
        var setQuotes = Set(learnQuotesLoadable.valueOrEmpty.map(\.rID) )

        while numberOfNewQuotes > 0 {
            if let newQuoteID = quoteIDs.randomElement() {
                if !setQuotes.contains(newQuoteID) {
                    newQuoteIDs.append(newQuoteID)
                    setQuotes.insert(newQuoteID)
                    numberOfNewQuotes -= 1
                }

            } else {
                break
            }
        }

        return newQuoteIDs
    }

    func createLearnQuote(newQuoteIDs: [String], date: Date) -> AnyPublisher<Void, Error> {
        let itemsData = newQuoteIDs.map {
            [
                DB.Fields.quoteID: $0,
                DB.Fields.createdAt: Date()
            ]
        }

        return dbManager.create([
            (
                items: itemsData,
                collectionPath: DB.learnQuotes,
                documentKey: nil
            ),
            (
                items: [[DB.Fields.value: date]],
                collectionPath: DB.userSettings,
                documentKey: DB.KeyID.toDate
            )
        ])
    }
}
