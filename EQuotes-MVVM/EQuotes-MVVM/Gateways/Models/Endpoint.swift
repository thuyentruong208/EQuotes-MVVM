//
//  Endpoint.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 04/05/2023.
//

import Foundation

struct NullBody: Encodable {

}

struct RequestData<T: Encodable> {

    let method: String
    let path: String
    let queryItems: [URLQueryItem]
    let body: T
    let formData: FormData?

    init(method: String = "GET",
         path: String,
         queryItems: [URLQueryItem] = [],
         body: T = NullBody(),
         formData: FormData? = nil
    ) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.body = body
        self.formData = formData
    }
}
