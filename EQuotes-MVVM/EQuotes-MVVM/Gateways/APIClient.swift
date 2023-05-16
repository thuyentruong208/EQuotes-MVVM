//
//  APIClient.swift
//  EQuotes
//
//  Created by Thuyên Trương on 18/09/2022.
//

import Foundation
import Combine

protocol APIClient {
    func buildRequest<T>(on api: APIHost, with data: RequestData<T>) -> URLRequest?

    func execute<T, R: Decodable>(
        on APIHost: APIHost,
        with data: RequestData<T>
    ) async throws -> R
}

extension APIClient {
    func buildRequest<T>(on api: APIHost, with data: RequestData<T>) -> URLRequest? {
        var components = URLComponents()
        components.scheme = api.scheme
        components.host = api.host
        components.path = "/" + data.path
        components.queryItems = data.queryItems.isEmpty ? nil : data.queryItems

        // If either the path or the query items passed contained
        // invalid characters, we'll get a nil URL back:
        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = data.method

        for (key, value) in api.headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        if let accessToken = api.accessToken {
            request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }

        if !(data.body is NullBody) {
            // if there is the body, attach -H "Content-Type: application/json"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .withoutEscapingSlashes
            request.httpBody = try? jsonEncoder.encode(data.body)
        } else if let formData = data.formData {
            let boundary = UUID().uuidString
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var body = [UInt8]()
            body.append(contentsOf: "--\(boundary)\r\n".utf8)
            body.append(contentsOf: "Content-Disposition:form-data; name=\"\(formData.name)\"; filename=\"\(formData.name)\"\r\n".utf8)
            body.append(contentsOf: "Content-Type: \(formData.contentType)\r\n\r\n".utf8)
            body.append(contentsOf: formData.data)
            body.append(contentsOf: "\r\n".utf8)
            body.append(contentsOf: "--\(boundary)--\r\n".utf8)
            request.httpBody = Data(body)
        }

        return request
    }
}

class RealAPIClient: APIClient {

    // MARK: - Properties
    fileprivate let session: URLSession

    init(session: URLSession = APIClientProvider.session) {
        self.session = session
    }

    func execute<T, R: Decodable>(
        on host: APIHost,
        with data: RequestData<T>
    ) async throws -> R {
        guard let request = buildRequest(on: host, with: data) else {
            throw APIError.invalidEndpoint(endpoint: data.path)
        }

        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(R.self, from: data)
    }
}
