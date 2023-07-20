//
//  User.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 20.7.23.
//

import Foundation

struct UserResponse: Codable {
    let user: User
}

struct User: Codable {
    let email: String
    let imageUrl: String?
    let id: String

    enum CodingKeys: String, CodingKey {
        case email
        case imageUrl = "image_url"
        case id
    }
}
