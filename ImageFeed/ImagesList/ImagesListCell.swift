//
//  ImageListCellTableViewCell.swift
//  ImageFeed
//
//  Created by mihail on 13.10.2023.
//

import UIKit

class ImagesListCell: UITableViewCell {
    //MARK: - IB Outlets
    @IBOutlet private var imagePoster: UIImageView!
    @IBOutlet private var labelDate: UILabel!
    @IBOutlet private var buttonLike: UIButton!
    @IBOutlet private var view: UIView!
    
    //MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    
    //MARK: - Privates Properties
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
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
        
        if indexPath.row % 2 == 0 {
            guard let image = UIImage(named: "No active") else { return }
            cell.buttonLike.setImage(image, for: .normal)
        } else {
            guard let image = UIImage(named: "Active") else { return }
            cell.buttonLike.setImage(image, for: .normal)
        }
    }
}
