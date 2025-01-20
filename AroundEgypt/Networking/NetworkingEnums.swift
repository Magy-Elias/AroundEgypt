//
//  NetworkingEnums.swift
//  AroundEgypt
//
//  Created by MagyElias on 19/01/2025.
//

import Foundation

enum Api {
    case recommendedExperiences
    case recentExperiences
    case searchExperiences(searchText: String)
    case experienceDetails(id: String)
    case likeExperience(id: String)
    
    var url: String {
        switch self {
        case .recommendedExperiences:
            return "/api/v2/experiences?filter[recommended]=true"
        case .recentExperiences:
            return "/api/v2/experiences"
        case .searchExperiences(let searchText):
            return "/api/v2/experiences?filter[title]=\(searchText)"
        case .experienceDetails(let id):
            return "/api/v2/experiences/\(id)"
        case .likeExperience(let id):
            return "/api/v2/experiences/\(id)/like"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .likeExperience:
            return .post
        default:
            return .get
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
