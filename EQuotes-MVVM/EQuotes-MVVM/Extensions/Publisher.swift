//
//  Publisher.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 20/04/2023.
//

import Foundation
import Combine

extension Publisher {
    func mapToLoadble<T>(_ result: @escaping (Loadable<T>) -> Void) -> AnyCancellable {
        sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                logger.error("Error: \(error)")
                result(.failed(error))
            default: break
            }
        }, receiveValue: { value in
            guard let value = value as? T else {
                return
            }
            result(.loaded(value))
        })
    }
}
