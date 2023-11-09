//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by mihail on 08.11.2023.
//

import UIKit

protocol WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class AuthViewController: UIViewController {
    let identifierSegue = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
    
}
