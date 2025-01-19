//
//  MockURLProtocol.swift
//  AroundEgypt
//
//  Created by MagyElias on 19/01/2025.
//

import Foundation
import XCTest
import Combine
@testable import AroundEgypt

class MockURLProtocol: URLProtocol {
    static var mockResponse: (data: Data?, error: Error?, statusCode: Int)?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let mockResponse = MockURLProtocol.mockResponse {
            if let data = mockResponse.data {
                let response = HTTPURLResponse(url: request.url!,
                                               statusCode: mockResponse.statusCode,
                                               httpVersion: nil,
                                               headerFields: nil)
                client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
            }
            if let error = mockResponse.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
