//
//  EnglishAPI.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 23/04/2023.
//

import Foundation

protocol EnglishAPI {
    func translate(_ text: String) async throws -> String
}

class RealEnglishAPI: RealAPIClient, EnglishAPI {
    func translate(_ text: String) async throws -> String {
        let translateResponse: TranslateResponse = try await execute(
            on: .translationHost,
            with: .init(
                method: "POST",
                path: "language/translate/v2",
                queryItems: [
                    URLQueryItem(name: "key", value: APIClientProvider.translateAPIKey)
                ],
                body: [
                    "q": text,
                    "source": "en",
                    "target": "vi",
                    "format": "text"
                ]
            )
        )

        return translateResponse.translatedText.first ?? ""
    }
}
