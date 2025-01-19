//
//  ApiServiceTests.swift
//  AroundEgyptTests
//
//  Created by MagyElias on 19/01/2025.
//

import XCTest
import Combine
@testable import AroundEgypt

class ApiServiceTests: XCTestCase {
    
    var apiService: ApiService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        apiService = ApiService(session: session)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        super.tearDown()
        // Clean up
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

    // Test for fetchExperienceDetails
    func testFetchExperienceDetailsSuccess() {
        let mockData = """
        {
            "data": {
                "id": "1",
                "title": "Test Experience",
                "description": "A great experience",
                "cover_photo": "",
                "views_no": 204,
                "likes_no": 123,
                "city": {
                    "id": 12,
                    "name": "Test City Name"
                }
            }
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponse = (data: mockData, error: nil, statusCode: 200)
        
        let expectation = self.expectation(description: "fetchExperienceDetails success")
        
        apiService.fetchExperienceDetails(id: "1")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { (response: ExperienceDetailsResponse) in
                XCTAssertEqual(response.data.title, "Test Experience")
                XCTAssertEqual(response.data.viewsNo, 204)
                XCTAssertEqual(response.data.likesNo, 123)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2)
    }
    
    func testFetchExperienceDetailsFailure() {
        MockURLProtocol.mockResponse = (data: nil, error: URLError(.badServerResponse), statusCode: 500)
        
        let expectation = self.expectation(description: "fetchExperienceDetails failure")

        apiService.fetchExperienceDetails(id: "1")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
                    expectation.fulfill() // Fulfill here
                case .finished:
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { (response: ExperienceDetailsResponse) in
                XCTFail("Expected failure but got response: \(response)")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }
    
    // Test for likeExperience
    func testLikeExperienceSuccess() {
        let mockData = """
        {
            "data": 124
        }
        """.data(using: .utf8)
        
        MockURLProtocol.mockResponse = (data: mockData, error: nil, statusCode: 200)
        
        let expectation = self.expectation(description: "likeExperience success")
        
        apiService.likeExperience(id: "1")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { (response: ExperienceLikesResponse) in
                XCTAssertEqual(response.data, 124)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2)
    }
    
    func testLikeExperienceFailure() {
        MockURLProtocol.mockResponse = (data: nil, error: URLError(.badServerResponse), statusCode: 500)
        
        let expectation = self.expectation(description: "likeExperience failure")
        
        apiService.likeExperience(id: "1")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
                    expectation.fulfill() // Fulfill here
                case .finished:
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { (response: ExperienceLikesResponse) in
                XCTFail("Expected failure but got response: \(response)")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2)
    }
    
    // Test for downloadImage
    func testDownloadImageSuccess() {
        let mockImage = UIImage(systemName: "star")
        let mockData = mockImage?.pngData()
        
        MockURLProtocol.mockResponse = (data: mockData, error: nil, statusCode: 200)
        
        let expectation = self.expectation(description: "downloadImage success")
        
        apiService.downloadImage(from: "https://example.com/image.png")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { image in
                XCTAssertNotNil(image)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2)
    }
    
    func testDownloadImageFailure() {
        MockURLProtocol.mockResponse = (data: nil, error: URLError(.badURL), statusCode: 400)
        
        let expectation = self.expectation(description: "downloadImage failure")
        
        apiService.downloadImage(from: "https://example.com/invalid.png")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual((error as? URLError)?.code, .badURL)
                    expectation.fulfill() // Fulfill here
                case .finished:
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { image in
                XCTFail("Expected failure but got image: \(String(describing: image))")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2)
    }
}
