//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by mihail on 28.11.2023.
//

import Foundation

protocol ProfileImageService {
    func fetchProfileImageURL(_ userName: String, completion: @escaping (Result<UserResult, Error>) -> Void)
    var avatarUrl: String? { get }
}

final class ProfileImageServiceImpl: ProfileImageService {
    static let DidhangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageServiceImpl()
    private let storage = OAuth2TokenStorage()
    private let session = URLSession.shared
    var avatarUrl: String?
    
    func fetchProfileImageURL(_ userName: String, completion: @escaping (Result<UserResult, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/users/\(userName)"),
              let token = storage.token else { return }
        
        var request = URLRequest(url: url)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization" )
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let urlResult):
                self.avatarUrl = urlResult.profileImage.small
                completion(.success(urlResult))
            case .failure(let error):
                completion(.failure (error))
            }
        }
        
        task.resume()
    }
}
