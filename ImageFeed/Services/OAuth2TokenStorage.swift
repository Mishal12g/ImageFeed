//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by mihail on 13.11.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let tokenKey = "BearerTokenKey"
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
