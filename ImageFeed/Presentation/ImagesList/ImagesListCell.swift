//
//  ImageListCellTableViewCell.swift
//  ImageFeed
//
//  Created by mihail on 13.10.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    //MARK: - IB Outlets
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet private weak var view: UIView!
    
    //MARK: - Public Properties
    weak var delegate: ImagesListCellDelegate?
    
    //MARK: - Static Properties
    static let reuseIdentifier = "ImagesListCell"
    
    //MARK: - Overrides methods
    override func awakeFromNib() {
        super.awakeFromNib()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.ypGradientOne.cgColor, UIColor.ypGradientTwo.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePoster.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}

extension ImagesListCell {
    func setIsLiked(_ isLiked: Bool) {
        if !isLiked  {
            buttonLike.setImage(UIImage(named: "No active"), for: .normal)
        } else {
            buttonLike.setImage(UIImage(named: "Active"), for: .normal)
        }
    }
}

