//
//  Photo.swift
//  ImageFeed
//
//  Created by mihail on 04.12.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let isLiked: Bool
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case description
        case createdAt = "created_at"
        case isLiked = "liked_by_user"
        case urls
    }
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
