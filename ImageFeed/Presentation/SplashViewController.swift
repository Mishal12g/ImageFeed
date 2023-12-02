//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by mihail on 15.11.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    //MARK: - Privates properties
    private let oauth2Service = OAuth2ServiceImpl()
    private let profileService = ProfileServiceImpl()
    private let storage = OAuth2TokenStorage()
    
    private let profileImageService = ProfileImageServiceImpl.shared
    
    private var alert: AlertDelegate?
    private var splashView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 76 , height: 75))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Splash screen")
        
        return imageView
    }()
    
    //MARK: - Overrides methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            fetchProfile(token)
        } else {
            showAuthViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(splashView)
        view.backgroundColor = .ypBlack
        addConstraints()
    }
}

//MARK: - for methods
extension SplashViewController {
    
    //MARK: - Privates methods
    private func showAuthViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            splashView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
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
            case .success(let authBody):
                self.storage.token = authBody.accessToken
                self.fetchProfile(authBody.accessToken)
            case .failure(let error):
                print(error)
                let model = AlertModel(title: "Что-то пошло не так(",
                                       message: "Не удалось войти в систему",
                                       buttonText: "Ок") {}
                alert?.show(model: model)
                
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                profileImageService.fetchProfileImageURL(profileResult.username) { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
}
