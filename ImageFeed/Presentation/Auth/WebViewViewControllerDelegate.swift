//
//  WebViewControllerDelegate.swift
//  ImageFeed
//
//  Created by mihail on 13.11.2023.
//

import Foundation

protocol WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
