//
//  APIClient.swift
//  EQuotes
//
//  Created by Thuyên Trương on 18/09/2022.
//

import Foundation
import Combine

protocol APIClient {
    func buildRequest<T: Encodable>(method: String?,
                       path: String,
                       headers: [String: String]?,
                       queryItems: [String: String]?,
                       formData: FormData?,
                                    body: T?) -> URLRequest
}

extension APIClient {
    func buildRequest<T: Encodable>(method: String? = "GET",
                      path: String,
                      headers: [String: String]? = nil,
                      queryItems: [String: String]? = nil,
                      formData: FormData? = nil,
                      body: T? = nil) -> URLRequest {

        return buildRequest(method: method,
                            path: path,
                            headers: headers,
                            queryItems: queryItems,
                            formData: formData,
                            body: body)
    }
}

class RealAPIClient: APIClient {


    // MARK: - Properties
    fileprivate let baseURL: URL
    fileprivate let session: URLSession

    fileprivate static let logIgnoreEndpoints: [String] = []
    fileprivate static let logFilterRegex = #""[^"]*(key|id|jwt|address|descriptor|signature|password|email|phone|shard|secret|receipt_data)[^"]*"\s*:\s*("[^"]*"|\d+(.\d+)|\[[^\]]*\]|\{[^\{]*\}),*"#

    init(baseURLString: String, session: URLSession = APIClientProvider.session) {
        guard let baseURL = URL(string: baseURLString) else {
            fatalError("invalid endpoint")
        }

        self.baseURL = baseURL
        self.session = session
    }

    func buildRequest<T: Encodable>(method: String?,
                      path: String,
                      headers: [String : String]?,
                      queryItems: [String : String]?,
                      formData: FormData?,
                    body: T?) -> URLRequest {

        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            fatalError("invalid base url")
        }

        urlComponents.path += path
        if let queryItems = queryItems {
            var items = [URLQueryItem]()
            for (key, value) in queryItems {
                items.append(URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = items
        }

        guard let url = urlComponents.url else {
            fatalError("invalid url")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let headers = headers {
            for (k, v) in headers {
                urlRequest.addValue(v, forHTTPHeaderField: k)
            }
        }

        if let body = body {
            // if there is the body, attach -H "Content-Type: application/json"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .withoutEscapingSlashes
            urlRequest.httpBody = try? jsonEncoder.encode(
                body
            )
        } else if let formData = formData {
            let boundary = UUID().uuidString
            urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var body = [UInt8]()
            body.append(contentsOf: "--\(boundary)\r\n".utf8)
            body.append(contentsOf: "Content-Disposition:form-data; name=\"\(formData.name)\"; filename=\"\(formData.name)\"\r\n".utf8)
            body.append(contentsOf: "Content-Type: \(formData.contentType)\r\n\r\n".utf8)
            body.append(contentsOf: formData.data)
            body.append(contentsOf: "\r\n".utf8)
            body.append(contentsOf: "--\(boundary)--\r\n".utf8)
            urlRequest.httpBody = Data(body)
        }

        return urlRequest
    }
}
