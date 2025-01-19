//
//  ApiService.swift
//  AroundEgypt
//
//  Created by MagyElias on 18/01/2025.
//

import Foundation
import UIKit
import Combine

class ApiService {
    private let baseURL: String = "https://aroundegypt.34ml.com"
    private let urlSession: URLSession
    
    init(session: URLSession = .shared) {
        self.urlSession = session
    }

    func fetchExperienceDetails(id: String) -> AnyPublisher<ExperienceDetailsResponse, Error> {
        let api = Api.experienceDetails(id: id)
        return performRequest(api: api, method: api.method)
    }

    func likeExperience(id: String) -> AnyPublisher<ExperienceLikesResponse, Error> {
        let api = Api.likeExperience(id: id)
        return performRequest(api: api, method: api.method)
    }

    // Function to download an image from a URL
    func downloadImage(from imageUrl: String) -> AnyPublisher<UIImage?, Error> {
        guard let url = URL(string: imageUrl) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        // Use URLSession's dataTaskPublisher to fetch image data
        return urlSession.dataTaskPublisher(for: url)
            .tryMap { data, response in
                // Check for valid HTTP response status codes
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .map { data in
                // Convert data into UIImage
                return UIImage(data: data)
            }
            .mapError { error in
                // Map any errors to a generic Error type
                error as Error
            }
            .eraseToAnyPublisher()
    }

    private func performRequest<T: Codable>(api: Api, method: HTTPMethod = .get) -> AnyPublisher<T, Error> {
        guard let url = URL(string: "\(baseURL)\(api.url)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        // Perform the network request and decode the response
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                // Check the response status code
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder()) // Decode response into type T
            .mapError { error in
                error as Error
            }
            .eraseToAnyPublisher()
    }
}
