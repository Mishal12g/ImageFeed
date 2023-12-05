//
//  ImagesLIstService.swift
//  ImageFeed
//
//  Created by mihail on 04.12.2023.
//

import Foundation

class ImagesListService {
    let session = URLSession.shared
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage(token: String, completion: @escaping (Result<Photo, Error>) -> Void) {
        let nextPage = lastLoadedPage == nil ? 1 : (lastLoadedPage ?? 1) + 1
        guard let url = URL(string: "https://api.unsplash.com/photos"),
              var urlComponents = URLComponents(string: url.absoluteString) else { return }
        
        urlComponents.queryItems = [
        URLQueryItem(name: "page", value: "\(nextPage)"),
        URLQueryItem(name: "per_page", value: "10")
        ]
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization" )
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<Photo, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let photo):
                photos.append(photo)
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                object: self,
                                                userInfo: ["Photos" : photos])
            case .failure(let error):
                print(error)
            }
        }
        
        task.resume()
    }
}
