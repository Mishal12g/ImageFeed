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
    let completion: () -> Void
}