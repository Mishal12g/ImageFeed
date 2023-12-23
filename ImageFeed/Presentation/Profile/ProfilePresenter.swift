//
//  File.swift
//  ImageFeed
//
//  Created by mihail on 23.12.2023.
//

import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func exitProfileAction() -> AlertModel
    func cleanToken()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    func exitProfileAction() -> AlertModel {
        let model = AlertModel(title: "Пока, пока!",
                               message: "Уверены что хотите выйти?",
                               buttonText: "Да",
                               buttonText2: "Нет"){
            self.cleanToken()
        }
        
        return model
    }
    
    func cleanToken() {
        WebKitClean.clean()
        OAuth2TokenStorage().removeToken()
        let splashViewController = SplashViewController()
        
        if let mainWindow = UIApplication.shared.windows.first {
            mainWindow.rootViewController = splashViewController
        }
    }
}
