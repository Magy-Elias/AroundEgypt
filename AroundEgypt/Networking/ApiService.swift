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

    func fetchRecommendedExperiences() -> AnyPublisher<ExperiencesListResponse, Error> {
        let api = Api.recommendedExperiences
        return performRequest(api: api, method: api.method)
    }

    func fetchRecentExperiences() -> AnyPublisher<ExperiencesListResponse, Error> {
        let api = Api.recentExperiences
        return performRequest(api: api, method: api.method)
    }

    func searchExperiences(searchText: String) -> AnyPublisher<ExperiencesListResponse, Error> {
        let api = Api.searchExperiences(searchText: searchText)
        return performRequest(api: api, method: api.method)
    }

    func fetchExperienceDetails(id: String) -> AnyPublisher<ExperienceDetailsResponse, Error> {
        let api = Api.experienceDetails(id: id)
        return performRequest(api: api, method: api.method)
    }

    func likeExperience(id: String) -> AnyPublisher<ExperienceLikesResponse, Error> {
        let api = Api.likeExperience(id: id)
        return performRequest(api: api, method: api.method)
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
