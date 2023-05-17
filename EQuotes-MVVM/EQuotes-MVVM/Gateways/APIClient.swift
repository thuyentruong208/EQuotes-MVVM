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
    fileprivate static let logFilterRegex = #""[^"]*(key|id|jwt|address|descriptor|signature|password|email|phone|shard|secret|receipt_data)[^"]*"\s*:\s*("[^"]*"|\d+(.\d+)|\[[^\]]*\]|\{[^\{]*\}),*"#

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

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        DispatchQueue.global().async {
            logger.debug("------------REQUEST FROM SERVER------------")
            logger.info("\(request.curlString)")
            logger.debug("------------RESPONSE FROM SERVER------------")
            if 400 ..< 600 ~= httpResponse.statusCode {
                logger.error("HTTP Status code: \(httpResponse.statusCode) | \(String(data: data, encoding: .utf8) ?? "")")
                logger.debug("------------END RESPONSE FROM SERVER------------")
            } else {
                #if DEBUG
                logger.info("HTTP Status code: \(httpResponse.statusCode) | \(String(data: data, encoding: .utf8) ?? "")")
                #else
                do {
                    if !Self.logIgnoreEndpoints.contains(where: { request.url?.absoluteString.contains($0) ?? false }),
                       let responseStr = String(data: data, encoding: .utf8) {
                        let regex = try NSRegularExpression(pattern: APIClient.logFilterRegex, options: .caseInsensitive)
                        let logStr = regex.stringByReplacingMatches(in: responseStr,
                                                                    range: NSRange(location: 0, length: responseStr.count),
                                                                    withTemplate: "")
                        logger.info("HTTP Status code: \(httpResponse.statusCode) | \(logStr)")
                    } else {
                        logger.info("HTTP Status code: \(httpResponse.statusCode) ... ")
                    }
                } catch {
                    logger.error("Error parsing response for logging")
                }
                #endif
                logger.debug("------------END RESPONSE FROM SERVER------------")
            }
        }

        if 400 ..< 600 ~= httpResponse.statusCode {
            if httpResponse.statusCode == 404 {
                throw APIError.notFound
            } else {
                let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
                throw APIError.apiError(code: errorResponse.error.code,
                                        reason: errorResponse.error.message)
            }
        }

        return try JSONDecoder().decode(R.self, from: data)
    }
}


extension URLRequest {
    var curlString: String {

        var regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: RealAPIClient.logFilterRegex, options: .caseInsensitive)
        } catch {
            logger.error("Error parsing response for logging")
        }

        var result = ""

        result += "curl -k "

        if let method = httpMethod {
            result += "-X \(method) \\\n"
        }

        #if DEBUG
        if let headers = allHTTPHeaderFields {
            for (header, value) in headers {
                result += "-H \"\(header): \(value)\" \\\n"
            }
        }

        if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
            result += "-d '\(string)' \\\n"
        }
        #else
        if let regex = regex {
            if let headers = allHTTPHeaderFields {
                for (header, value) in headers {
                    let headerLog = regex.stringByReplacingMatches(in: value,
                                                                   range: NSRange(location: 0, length: value.count),
                                                                   withTemplate: "")
                    result += "-H \"\(header): \(headerLog)\" \\\n"
                }
            }

            if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
                let bodyLog = regex.stringByReplacingMatches(in: string,
                                                             range: NSRange(location: 0, length: string.count),
                                                             withTemplate: "")
                result += "-d '\(bodyLog)' \\\n"
            }
        }
        #endif

        if let url = url {
            result += url.absoluteString
        }

        return result
    }
}
