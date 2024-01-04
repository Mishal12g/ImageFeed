//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by mihail on 23.12.2023.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var photos: [PhotoViewModel] { get set }
    var view: ImagesListViewControllerProtocol? { get set }
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [PhotoViewModel] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    
    func photosNotification() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification,
                                                                           object: nil,
                                                                           queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.view?.updateTableViewAnimated()
        }
    }
    
    func convert(photoResult: [PhotoResult]) {
        var photos = [PhotoViewModel]()
        photoResult.forEach { result in
            let date = DateFormattesHelper.dateFormatter.date(from: result.createdAt)
            let photoModel = PhotoViewModel(id: result.id,
                                            size: CGSize(width: result.width, height: result.height),
                                            createdAt: date,
                                            welcomeDescription: result.description,
                                            thumbImageURL: result.urls.thumb,
                                            mediumImageURL: result.urls.small,
                                            largeImageURL: result.urls.full,
                                            isLiked: result.isLiked)
            
            photos.append(photoModel)
        }
        self.photos = photos
    }
}
