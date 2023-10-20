//
//  ViewController.swift
//  ImageFeed
//
//  Created by mihail on 06.10.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    //MARK: - IB outlets
    @IBOutlet private var table: UITableView!
    
    //MARK: - Privates properties
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        table.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        table.register(UINib(nibName: "ImagesListCell", bundle: nil), forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    }
}

//MARK: - UITableView Data Source
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.configCell(for: imageListCell, with: indexPath, photosName: photosName)
        
        return imageListCell
    }
}

//MARK: - UITableView delegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

