//
//  Loadable.swift
//  EQuotes
//
//  Created by Thuyên Trương on 30/08/2022.
//

import Foundation
import Combine

extension Loadable where T: Collection {
    var valueOrEmpty: T {
        if let value = value {
            return value
        } else {
            return [T.Element]() as! T
        }
    }
}

enum Loadable<T> {

    case notRequested
    case isLoading(last: T?)
    case loaded(T)
    case failed(Error)

    var value: T? {
        switch self {
        case let .loaded(value): return value
        case let .isLoading(last): return last
        default: return nil
        }
    }



    var error: Error? {
        switch self {
        case let .failed(error): return error
        default: return nil
        }
    }
}

extension Loadable {
    mutating func setIsLoading() {
        self = .isLoading(last: value)
    }

    mutating func endIsLoading() {
        if let value = value {
            self = .loaded(value)
        } else {
            self = .notRequested
        }
    }
}

extension Loadable: Equatable where T: Equatable {
    static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.notRequested, .notRequested): return true
        case let (.isLoading(lhsV), .isLoading(rhsV)): return lhsV == rhsV
        case let (.loaded(lhsV), .loaded(rhsV)): return lhsV == rhsV
        case let (.failed(lhsE), .failed(rhsE)):
            return lhsE.localizedDescription == rhsE.localizedDescription
        default: return false
        }
    }
}

