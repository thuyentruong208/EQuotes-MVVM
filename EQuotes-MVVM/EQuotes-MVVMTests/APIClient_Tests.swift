//
//  APIClient_Tests.swift
//  EQuotes-MVVMTests
//
//  Created by Thuyên Trương on 16/05/2023.
//

import XCTest
@testable import EQuotes_MVVM

final class APIClient_Tests: XCTestCase {

    private let apiHost = APIHost(
        scheme: "https",
        host: "example.com"
    )
    private let secretAPIHost = APIHost(
        scheme: "https",
        host: "example.com",
        accessToken: "SECRET_TOKEN"
    )
    private var client: APIClient!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        client = RealAPIClient(session: urlSession)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_buildRequest_GetRequestWithNoQuery_ReturnsSuccessfully() throws {
        let request = try XCTUnwrap(client.buildRequest(on: apiHost, with: .init(path: "path")))
        XCTAssertEqual(request.url?.absoluteString, "https://example.com/path")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func test_buildRequest_GetRequestWithQuery_ReturnsSuccessfully() throws {
        let request = try XCTUnwrap(client.buildRequest(on: apiHost, with: .init(
            path: "path",
            queryItems: [URLQueryItem(name: "item1", value: "1")]
        )))
        XCTAssertEqual(request.url?.absoluteString, "https://example.com/path?item1=1")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func test_buildDeleteRequest_ReturnsSuccessfully() throws {
        let request = try XCTUnwrap(client.buildRequest(
            on: secretAPIHost
            , with: .init(
                method: "DELETE",
                path: "path",
                queryItems: [URLQueryItem(name: "item1", value: "1")]
            )))
        XCTAssertEqual(request.url?.absoluteString, "https://example.com/path?item1=1")
        XCTAssertEqual(request.httpMethod, "DELETE")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer SECRET_TOKEN")
    }

    func test_buildPostRequest_ReturnsSuccessfully() throws {
        let body = ["data": "123456"]
        let request = try XCTUnwrap(client.buildRequest(
            on: secretAPIHost
            , with: .init(
                method: "POST",
                path: "path",
                queryItems: [URLQueryItem(name: "item1", value: "1")],
                body: body
            )))
        XCTAssertEqual(request.url?.absoluteString, "https://example.com/path?item1=1")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer SECRET_TOKEN")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")

        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .withoutEscapingSlashes
        XCTAssertEqual(request.httpBody, try jsonEncoder.encode(body))
    }

    // MARK: test_execute
    func test_execute_Successfully() async throws {
        let resultData = "{ \"result\": \"success\" }".data(using: .utf8)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, resultData)
        }

        let data: [String: String] = try await client.execute(on: secretAPIHost, with: .init(
            method: "POST",
            path: "path") )

        XCTAssertEqual(data, ["result": "success"])
    }

    func test_execute_Fail404NotFound() async throws {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }

        do {
            let _: String = try await self.client.execute(
                on: self.secretAPIHost,
                with: .init(
                    method: "POST",
                    path: "path"
                ))
        } catch (let error) {
            XCTAssertEqual(error as? APIError, APIError.notFound)
        }
    }

    func test_execute_Fail400BadRequest() async throws {
        let resultData = try JSONEncoder().encode(APIErrorResponse(error: APIErrorObject(code: 400, message: "Bad Request")))

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (response, resultData)
        }

        do {
            let _: String = try await self.client.execute(
                on: self.secretAPIHost,
                with: .init(
                    method: "POST",
                    path: "path"
                ))
        } catch (let error) {
            XCTAssertEqual(error as? APIError, APIError.apiError(code: 400, reason: "Bad Request"))
        }
    }
}
