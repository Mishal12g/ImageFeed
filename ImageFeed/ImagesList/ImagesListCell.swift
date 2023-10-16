//
//  ImageListCellTableViewCell.swift
//  ImageFeed
//
//  Created by mihail on 13.10.2023.
//

import UIKit

class ImagesListCell: UITableViewCell {
    //MARK: - IB Outlets
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var buttonLike: UIButton!
    @IBOutlet var view: UIView!
    
    //MARK: - Public Properties
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
}
