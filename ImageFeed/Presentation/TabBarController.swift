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
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
