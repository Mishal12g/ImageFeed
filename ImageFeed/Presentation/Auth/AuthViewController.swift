//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by mihail on 08.11.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    //MARK: - Private properties
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    //MARK: - Public properties
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: - Overrides methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(didAuthenticateWithCode code: String) {
        delegate?.authViewController(didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
