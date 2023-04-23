//
//  Publisher.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import Foundation
import Combine

extension Publisher {
    func mapToLoadble<T>(_ handler: @escaping (Loadable<T>) -> Void) -> AnyCancellable {
        sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                logger.error("Error: \(error)")
                handler(.failed(error))
            default: break
            }
        }, receiveValue: { value in
            guard let value = value as? T else {
                return
            }
            handler(.loaded(value))
        })
    }

    func generalCompletionHandler() -> AnyCancellable {
        sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                logger.error("Error: \(error)")
            default: break
            }
        }, receiveValue: { (_) in })
    }
}
