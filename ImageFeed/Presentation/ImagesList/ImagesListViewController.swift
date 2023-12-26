import UIKit
import ProgressHUD
import Kingfisher

protocol ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenter? { get set }
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    //MARK: - IB outlets
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Privates properties
    private let showSingleImageIdentifier = "ShowSingleImage"
    private let service = ImagesListService.shared
    var presenter: ImagesListPresenter?
    
    
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(UINib(nibName: ImagesListCell.reuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        service.fetchPhotosNextPage()
        presenter?.photosNotification()
    }
}

//MARK: - For methods
extension ImagesListViewController {
    func configure(_ presenter: ImagesListPresenter) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func updateTableViewAnimated() {
        guard let presenter = presenter else { return }
        let oldCount = presenter.photos.count
        let newCount = service.photos.count
        
        if oldCount != newCount {
            let indexPath = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            
            presenter.convert(photoResult: service.photos)
            
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
        guard let presenter = presenter else { return }
        cell.delegate = self
        cell.setGradient(width: Int(cell.frame.width), height: Int(cell.frame.height))
        cell.imagePoster.layer.cornerRadius = 16
        
        let photo = presenter.photos[indexPath.row]
        guard let date = photo.createdAt else { return }
        let dateString = DateFormattesHelper.outputDateFormatter.string(from: date)
        cell.labelDate.text = dateString
        cell.setIsLiked(photo.isLiked)
        
        if let url = URL(string: photo.largeImageURL) {
            let processor = RoundCornerImageProcessor(cornerRadius: 16)
            
            cell.imagePoster.kf.setImage(with: url,
                                         placeholder: UIImage(named: "loadImage"),
                                         options: [.processor(processor)]
            ) {[weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                cell.gradient.removeFromSuperlayer()
            }
        }
    }
}

//MARK: - UITableView Data Source
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0}
        return presenter.photos.count
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
        guard let presenter = presenter else { return }
        if indexPath.row + 1 == presenter.photos.count {
            service.fetchPhotosNextPage()
        }
    }
}

//MARK: - ImagesListCell Delegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let presenter = presenter else { return }
        let photo = presenter.photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        service.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] res in
            guard let self = self else { return }
            switch res {
            case .success:
                guard let presenter = self.presenter else { return }
                presenter.convert(photoResult: self.service.photos)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                cell.setIsLiked(presenter.photos[indexPath.row].isLiked)
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
        
        guard let presenter = presenter else { return 0}
        let photo = presenter.photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == showSingleImageIdentifier,
              let viewController = segue.destination as? SingleImageViewController,
              let indexPath = sender as? IndexPath,
              let presenter = presenter else {
            super.prepare(for: segue, sender: sender)
            return
        }
        
        let photo = presenter.photos[indexPath.row]
        
        guard let url = URL(string: photo.largeImageURL) else { return }
        viewController.imageUrl = url
    }
}
