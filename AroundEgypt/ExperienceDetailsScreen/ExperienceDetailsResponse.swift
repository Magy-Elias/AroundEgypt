//
//  ExperienceDetailsResponse.swift
//  AroundEgypt
//
//  Created by MagyElias on 19/01/2025.
//

struct ExperienceDetailsResponse: Codable {
    var data: ExperienceDetails
}

struct ExperienceDetails: Codable {
    let id: String
    let title: String
    let coverPhoto: String
    let description: String
    let viewsNo: Int
    let likesNo: Int
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, city
        case coverPhoto = "cover_photo"
        case viewsNo = "views_no"
        case likesNo = "likes_no"
    }
}

struct City: Codable {
    let id: Int
    let name: String
    let topPick: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case topPick = "top_pick"
    }
}
