//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by mihail on 28.11.2023.
//

import Foundation

protocol ProfileImageService {
    func fetchProfileImageURL(_ userName: String, completion: @escaping (Result<String, Error>) -> Void)
    var avatarUrl: String? { get }
}

final class ProfileImageServiceImpl: ProfileImageService {
    static let DidhangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageServiceImpl()
    private let storage = OAuth2TokenStorage()
    private let session = URLSession.shared
    var avatarUrl: String?
    
    func fetchProfileImageURL(_ userName: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/users/\(userName)"),
              let token = storage.token else { return }
        
        var request = URLRequest(url: url)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization" )
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }
            
            if response.statusCode < 200 || response.statusCode >= 300 {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidStatusCode(response.statusCode)))
                }
                return
            }
            
            do {
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.emptyData))
                    }
                    return
                }
                
                let user = try JSONDecoder().decode(UserResult.self, from: data)
                self.avatarUrl = user.profileImage.small
                guard let avatarUrl = self.avatarUrl else { return }
                
                DispatchQueue.main.async {
                    completion(.success(avatarUrl))
                    NotificationCenter.default.post(name: ProfileImageServiceImpl.DidhangeNotification,
                                                    object: self,
                                                    userInfo: ["URL": avatarUrl])

                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.emptyData))
                }
                return
            }
        }
        task.resume()
    }
}
