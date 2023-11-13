//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by mihail on 08.11.2023.
//

import UIKit



final class AuthViewController: UIViewController {
    let identifierSegue = "ShowWebView"
    let tokenStorage = OAuth2TokenStorage()
    let oauthService = OAuth2Service()
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
