//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by mihail on 10.11.2023.
//

import Foundation

final class OAuth2Service {
    //MARK: - Public methods
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.sync {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.sync {
                        completion(.failure(NetworkError.invalidResponse))
                    }
                    return
                }
                
                if 200..<300 ~= httpResponse.statusCode {
                    if let data = data,
                       let jsonString = String(data: data, encoding: .utf8) {
                        do {
                            let authResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: Data(jsonString.utf8))
                            let accessToken = authResponse.accessToken
                            
                            DispatchQueue.main.sync {
                                completion(.success(accessToken))
                            }
                        } catch {
                            DispatchQueue.main.sync {
                                completion(.failure(error))
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.sync {
                        completion(.failure(NetworkError.invalidStatusCode(httpResponse.statusCode)))
                    }
                }
            }
            
            task.resume()
        }
    }
}
