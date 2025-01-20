//
//  City.swift
//  AroundEgypt
//
//  Created by MagyElias on 19/01/2025.
//

struct City: Codable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }
}
