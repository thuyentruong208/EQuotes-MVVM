//
//  APIError.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 04/05/2023.
//

import Foundation

enum APIError: Error {
    case invalidEndpoint(endpoint: String)
}
