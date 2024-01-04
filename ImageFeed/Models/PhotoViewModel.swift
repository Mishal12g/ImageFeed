//
//  PhotoViewModel.swift
//  ImageFeed
//
//  Created by mihail on 06.12.2023.
//

import Foundation

struct PhotoViewModel {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let mediumImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
