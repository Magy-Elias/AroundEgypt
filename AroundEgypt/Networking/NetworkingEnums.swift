//
//  NetworkingEnums.swift
//  AroundEgypt
//
//  Created by MagyElias on 19/01/2025.
//

import Foundation

enum Api {
    case experienceDetails(id: String)
    case likeExperience(id: String)
    
    var url: String {
        switch self {
        case .experienceDetails(let id):
            return "/api/v2/experiences/\(id)"
        case .likeExperience(let id):
            return "/api/v2/experiences/\(id)/like"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .experienceDetails:
            return .get
        case .likeExperience:
            return .post
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
