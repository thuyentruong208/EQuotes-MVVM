//
//  MockURLResponder.swift
//  EQuotes-MVVMTests
//
//  Created by Thuyên Trương on 17/05/2023.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {

        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }

        guard let client = client else {
            return
        }

        do {
            let (response, data) = try handler(request)

            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if let data = data {
                client.urlProtocol(self, didLoad: data)
            }

        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }

        client.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Required method, implement as a no-op.
    }
}
