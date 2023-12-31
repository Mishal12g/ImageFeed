//
//  TabBarController.swift
//  ImageFeed
//
//  Created by mihail on 01.12.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController else { return }
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.configure(imagesListPresenter)
    
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profileViewController.configure(profilePresenter)
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
