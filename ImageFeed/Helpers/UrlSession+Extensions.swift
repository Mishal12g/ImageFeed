//
//  UrlSession+Extensions.swift
//  ImageFeed
//
//  Created by mihail on 29.11.2023.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(for request: URLRequest,
                                  completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletionOnMainThread(.success(result))
                    } catch {
                        fulfillCompletionOnMainThread(.failure(NetworkError.emptyData))
                    }
                } else {
                    fulfillCompletionOnMainThread(.failure(NetworkError.invalidStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnMainThread(.failure(error))
            } else {
                fulfillCompletionOnMainThread(.failure(NetworkError.invalidResponse))
            }
        }
        
        return task
    }
}

private enum NetworkError: Error {
    case emptyData
    case invalidResponse
    case invalidStatusCode(Int)
}
