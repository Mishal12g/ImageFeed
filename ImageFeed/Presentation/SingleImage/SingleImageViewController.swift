//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by mihail on 20.10.2023.
//

import UIKit
import Kingfisher

class SingleImageViewController: UIViewController {
    //MARK: - IB Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - Public properties
    var imageUrl: URL?
    
    var image: UIImage?
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        imageView.kf.setImage(with: imageUrl,
                              placeholder: UIImage(named: "loadImage")
        )
        
        rescaleAndCenterImageInScrollView(image: imageView.image ?? UIImage() )
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
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}
