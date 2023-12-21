//
//  AlertModel.swift
//  ImageFeed
//
//  Created by mihail on 29.11.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonText2: String?
    let completion: () -> Void
}
