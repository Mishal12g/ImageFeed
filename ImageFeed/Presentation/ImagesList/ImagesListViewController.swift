//
//  ViewController.swift
//  ImageFeed
//
//  Created by mihail on 06.10.2023.
//

import UIKit
import ProgressHUD
import Kingfisher

final class ImagesListViewController: UIViewController {
    //MARK: - IB outlets
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Privates properties
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let showSingleImageIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    private let service = ImagesListService.shared
    private var photos: [PhotoResult] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(UINib(nibName: ImagesListCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        service.fetchPhotosNextPage()
        imagesListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification,
                                                                           object: nil,
                                                                           queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
    }
}

//MARK: - For methods
private extension ImagesListViewController {
    func formatDateString(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: dateString) {
            
            let formattedString = dateFormatter.string(from: date)
            return formattedString
        } else {
            return nil
        }
    }
    
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = service.photos.count
        
        if oldCount != newCount {
            let indexPath = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            photos = service.photos
            tableView.performBatchUpdates {
                tableView.insertRows(at: indexPath, with: .automatic)
            }
        }
    }
    
    func setIsLiked(isLiked: Bool, cell: ImagesListCell) {
        if !isLiked {
            cell.buttonLike.setImage(UIImage(named: "No active"), for: .normal)
        } else {
            cell.buttonLike.setImage(UIImage(named: "Active"), for: .normal)
        }
    }
    
    func configCell(cell: ImagesListCell, indexPath: IndexPath) {
        cell.delegate = self
        let photo = photos[indexPath.row]
        let date = formatDateString(photo.createdAt)
        cell.labelDate.text = date
        cell.setIsLiked(photo.isLiked)
        if let url = URL(string: photo.urls.full) {
            let processor = RoundCornerImageProcessor(cornerRadius: 25)
            cell.imagePoster.kf.indicatorType = .activity
            cell.imagePoster.kf.setImage(with: url,
                                         placeholder: UIImage(named: "loadImage"),
                                         options: [.processor(processor)]
            ) {[weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

//MARK: - UITableView Data Source
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(cell: imageListCell, indexPath: indexPath)
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            service.fetchPhotosNextPage()
        }
    }
}

//MARK: - ImagesListCell Delegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        service.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] res in
            guard let self = self else { return }
            switch res {
            case .success:
                self.photos = self.service.photos
                tableView.reloadRows(at: [indexPath], with: .automatic)
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
            }
        }
        
    
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - UITableView delegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = UIImage(named: ("\(indexPath.row)"))
        guard let image = image else { return 0 }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showSingleImageIdentifier,
              let viewController = segue.destination as? SingleImageViewController,
              let indexPath = sender as? IndexPath else {
            super.prepare(for: segue, sender: sender)
            return
        }
        
        let photo = photos[indexPath.row]
        
        guard let url = URL(string: photo.urls.full) else { return }
        viewController.imageUrl = url
    }
}
