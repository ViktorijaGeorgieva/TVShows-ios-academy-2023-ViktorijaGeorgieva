//
//  Review.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 27.7.23.
//

import Foundation

struct Review: Codable {
    let id: String
    let comment: String
    let rating: Double
    let showId: Double
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rating
        case showId = "show_id"
        case user
    }
}
struct ReviewsResponse: Codable {
    let reviews: [Review]
}
struct ReviewResponse: Codable {
    let review: Review
}
