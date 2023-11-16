//
//  ImageListCellTableViewCell.swift
//  ImageFeed
//
//  Created by mihail on 13.10.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    //MARK: - IB Outlets
    @IBOutlet private weak var imagePoster: UIImageView!
    @IBOutlet private weak var labelDate: UILabel!
    @IBOutlet private weak var buttonLike: UIButton!
    @IBOutlet private weak var view: UIView!
    
    //MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    
    //MARK: - Privates Properties
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
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
    
    //MARK: - Public methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath, photosName: [String]) {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        cell.imagePoster.image = image
        
        let data = dateFormatter.string(from: Date())
        cell.labelDate.text = data
        
        let likeImage: UIImage?
               if indexPath.row % 2 == 0 {
                   likeImage = UIImage(named: "No active")
               } else {
                   likeImage = UIImage(named: "Active")
               }
               guard let likeImage = likeImage else { return }
               cell.buttonLike.setImage(likeImage, for: .normal)
    }
}
