//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by mihail on 15.11.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let oauth2Service = OAuth2Service()
    private let storage = OAuth2TokenStorage()
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let showImagesListSegue = "ShowImagesList"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let authViewController = navigationController.viewControllers[0] as? AuthViewController else {
                fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")
            }
            
            authViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController( didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let accessToken):
                self.storage.token = accessToken
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print(error)
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
}
