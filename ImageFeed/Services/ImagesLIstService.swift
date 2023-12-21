//
//  ImagesLIstService.swift
//  ImageFeed
//
//  Created by mihail on 04.12.2023.
//

import Foundation

class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    
    private let token = OAuth2TokenStorage().token
    private (set) var photos: [PhotoResult] = []
    private var lastLoadedPage: Int? = nil
    private var prevTask: URLSessionTask?
    private var nextPage = 0
    
    private init() {}
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<(), Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like"),
              let token = token else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? "POST" : "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
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
            
            if 200..<300 ~= response.statusCode {
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        
                        let newPhoto = PhotoResult(id: photo.id,
                                                   createdAt: photo.createdAt,
                                                   width: photo.width,
                                                   height: photo.height,
                                                   description: photo.description,
                                                   isLiked: !photo.isLiked,
                                                   urls: photo.urls)
                        
                        self.photos[index] = newPhoto
                        completion(.success(()))
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func fetchPhotosNextPage() {
        guard prevTask == nil else {
            return
        }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        lastLoadedPage = nextPage
        
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(nextPage)&per_page=10"),
              let token = token else {
            prevTask = nil
            return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        prevTask?.cancel()
        
        prevTask = URLSession.shared.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            defer {
                self.prevTask = nil
            }
            
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
        
        prevTask?.resume()
    }
}
