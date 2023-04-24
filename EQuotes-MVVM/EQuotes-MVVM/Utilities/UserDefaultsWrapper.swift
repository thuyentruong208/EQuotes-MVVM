//
//  UserDefaultWrapper.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 21/04/2023.
//

import Foundation
import SwiftUI

@propertyWrapper
struct UserDefault<Value> {

    let key: String
    let defaultValue: Value
    let container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

class LearnDefaults {

    public enum Keys {
        static let learnMode = "learnMode"
        static let todayLearnedCount = "todayLearnedCount"
        static let learnedAt = "learnedAt"
    }

    public static let shared = LearnDefaults()

    private init() {}

    @UserDefault(key: Keys.learnMode, defaultValue: false)
    var learnMode: Bool

    @UserDefault(key: Keys.todayLearnedCount, defaultValue: 0)
    var todayLearnedCount: Int

    @UserDefault(key: Keys.learnedAt, defaultValue: Date())
    var learnedAt: Date
}
