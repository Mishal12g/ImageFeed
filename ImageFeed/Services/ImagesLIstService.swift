//
//  ImagesLIstService.swift
//  ImageFeed
//
//  Created by mihail on 04.12.2023.
//

import Foundation

class ImagesListService {
    private (set) var photos: [PhotoResult] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    
    private init() {}
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : (lastLoadedPage ?? 1) + 1
        guard var urlComponents = URLComponents(string: "https://api.unsplash.com/photos") else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "client_id", value: "\(AccessKey)"),
        ]
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        
        task?.cancel()
        
        task = URLSession.shared.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photosResult):
                self.photos += photosResult
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                object: self,
                                                userInfo: ["Photos" : self.photos])
            case .failure(let error):
                print(error)
            }
        }
        
        task?.resume()
    }
}
