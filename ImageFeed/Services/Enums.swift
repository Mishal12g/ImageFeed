//
//  Enums.swift
//  ImageFeed
//
//  Created by mihail on 16.11.2023.
//

import Foundation

//MARK: - Enums
enum NetworkError: Error {
    case invalidResponse
    case invalidStatusCode(Int)
    case emptyData
}
