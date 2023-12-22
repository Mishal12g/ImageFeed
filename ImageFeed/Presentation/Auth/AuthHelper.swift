//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by mihail on 22.12.2023.
//

import Foundation

protocol AuthHelperProtocol: AnyObject {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
    private let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standart) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        guard let components = URLComponents(string: url.absoluteString),
              components.path == "/oauth/authorize/native",
              let codeItem = components.queryItems?.first(where: { $0.name == "code" }) else { return nil }
        
        return codeItem.value
    }
    
    private func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.unsplashAuthorizeURLString) else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        
        let url = urlComponents.url
        return url
    }
}
