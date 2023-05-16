//
//  APIHost.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 04/05/2023.
//

import Foundation

struct APIHost {
    let scheme: String
    let host: String
    let headers: [String: String]
    let accessToken: String?

    init(scheme: String, host: String, headers: [String : String] = [:], accessToken: String? = nil) {
        self.scheme = scheme
        self.host = host
        self.headers = headers
        self.accessToken = accessToken
    }
}

extension APIHost {
    static let translationHost = APIHost(
        scheme: "https",
        host: "translation.googleapis.com"
    )
}
