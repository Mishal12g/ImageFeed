//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by mihail on 20.10.2023.
//

import UIKit
import Kingfisher

class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    //MARK: - IB Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - Public properties
    var imageUrl: URL?
    
    var image: UIImage?
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageUrl) { [weak self] res in
            
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch res {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - IB Actions
    @IBAction private func onBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    //MARK: - Privates Methods
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
 
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
