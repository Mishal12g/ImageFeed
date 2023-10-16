//
//  ImageListCellTableViewCell.swift
//  ImageFeed
//
//  Created by mihail on 13.10.2023.
//

import UIKit

class ImagesListCell: UITableViewCell {

    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var buttonLike: UIButton!
    @IBOutlet var view: UIView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
       
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.ypGradientOne.cgColor, UIColor.ypGradientTwo.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
}
