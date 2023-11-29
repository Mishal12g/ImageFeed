//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by mihail on 10.11.2023.
//

import Foundation

protocol OAuth2Service {
    func fetchAuthToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void)
}

final class OAuth2ServiceImpl: OAuth2Service {
    //MARK: - Privates properties
    private let session = URLSession.shared
    
    private var lastCode: String?
    
    //MARK: - Public methods
    func fetchAuthToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        
        let request = makeRequest(code: code)
        let task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

//MARK: - Privates methods
private func makeRequest(code: String) -> URLRequest {
    guard
        let url = URL(string: "https://unsplash.com/oauth/token"),
        var urlComponents = URLComponents(string: url.absoluteString)
    else { fatalError("Failed to create URL")
    }
    
    urlComponents.queryItems = [
        URLQueryItem(name: "client_id", value: AccessKey),
        URLQueryItem(name: "client_secret", value: SecretKey),
        URLQueryItem(name: "redirect_uri", value: RedirectURI),
        URLQueryItem(name: "code", value: code),
        URLQueryItem(name: "grant_type", value: "authorization_code")
    ]
    
    var request = URLRequest(url: urlComponents.url ?? url)
    request.httpMethod = "POST"
    
    return request
}
