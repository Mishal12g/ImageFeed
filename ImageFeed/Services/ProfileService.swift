//
//  ProfileService.swift
//  ImageFeed
//
//  Created by mihail on 24.11.2023.
//

import Foundation

protocol ProfileService {
    func fetchProfile(token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void)
    var profile: ProfileViewModel? { get }
}

final class ProfileServiceImpl: ProfileService {
    static let shared = ProfileServiceImpl()
    private(set) var profile: ProfileViewModel?
    
    let session = URLSession.shared
    
    func fetchProfile(token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        guard let url =  URL(string: "https://api.unsplash.com/me") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                let profileModel = ProfileViewModel(name: "\(profile.firstName) \(profile.lastName)",
                                                    loginName: "@\(profile.username)",
                                                    bio: profile.bio)
                ProfileServiceImpl.shared.profile = profileModel
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
