//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by mihail on 10.11.2023.
//

import Foundation

protocol OAuth2Service {
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class OAuth2ServiceImpl: OAuth2Service {
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    //MARK: - Public methods
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let request = makeRequest(code: code)
        
        let task = urlSession.dataTask(with: request) { data, response, error in
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
                            self.task = nil
                            if error != nil {
                                self.lastCode = nil
                            }
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
        self.task = task
        task.resume()
    }
}

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
