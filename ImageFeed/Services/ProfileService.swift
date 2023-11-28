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
    
    let urlSession = URLSession.shared
    
    func fetchProfile(token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        guard let url =  URL(string: "https://api.unsplash.com/me") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }
            
            if 200..<300 ~= httpResponse.statusCode {
                guard let data = data,
                      let jsonString = String(data: data, encoding: .utf8) else { return }
                
                do {
                    let profile = try JSONDecoder().decode(ProfileResult.self, from: Data(jsonString.utf8))
                    let profileModel = ProfileViewModel(name: "\(profile.firstName) \(profile.lastName)",
                                                        loginName: "@\(profile.username)",
                                                        bio: profile.bio)
                    ProfileServiceImpl.shared.profile = profileModel
                    
                    DispatchQueue.main.async {
                        completion(.success(profile))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidStatusCode(httpResponse.statusCode)))
                }
            }
        }
        
        task.resume()
    }
}
