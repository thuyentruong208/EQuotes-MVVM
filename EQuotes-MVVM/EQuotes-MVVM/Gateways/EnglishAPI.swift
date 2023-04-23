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

class RealEnglishAPI {
    let client: APIClient

    init(client: APIClient = RealAPIClient(baseURLString: APIClientProvider.translateEndpoint)) {
        self.client = client
    }
}

extension RealEnglishAPI: EnglishAPI {

    func translate(_ text: String) async throws -> String {
        let request = client.buildRequest(
            method: "POST",
            path: "",
            queryItems: [
                "key": APIClientProvider.translateAPIKey
            ],
            body: [
                "q": text,
                "source": "en",
                "target": "vi",
                "format": "text"
            ]
        )

        let (data, _) = try await URLSession.shared.data(for: request)
        let translateResponse =  try JSONDecoder().decode(TranslateResponse.self, from: data)
        return translateResponse.translatedText.first ?? ""
    }
}
