//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by mihail on 24.11.2023.
//

import Foundation

struct ProfileResult: Codable {
    let firstName: String
    let lastName: String
    let username: String
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case username
        case bio
    }
}
