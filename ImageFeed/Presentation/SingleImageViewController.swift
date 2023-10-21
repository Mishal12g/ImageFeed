//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by mihail on 20.10.2023.
//

import UIKit

class SingleImageViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
