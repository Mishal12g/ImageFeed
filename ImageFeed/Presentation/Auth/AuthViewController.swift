//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by mihail on 08.11.2023.
//

import UIKit



final class AuthViewController: UIViewController {
    //MARK: - Private properties
    private let identifierSegue = "ShowWebView"
    private let tokenStorage = OAuth2TokenStorage()
    private let oauthService = OAuth2Service()
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oauthService.fetchAuthToken(code: code) { result in
            switch result {
             case .success(let accessToken):
                self.tokenStorage.token = accessToken
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
