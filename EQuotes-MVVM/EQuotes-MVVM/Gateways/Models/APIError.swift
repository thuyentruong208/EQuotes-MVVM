//
//  APIError.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 04/05/2023.
//

import Foundation

enum APIError: Error, Equatable {
    case invalidEndpoint(endpoint: String)
    case unknown
    case notFound
    case apiError(code: Int, reason: String)
}

struct APIErrorResponse: Codable {
    let error: APIErrorObject
}

struct APIErrorObject: Codable {
    let code: Int
    let message: String
}
