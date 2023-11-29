//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by mihail on 08.11.2023.
//

import UIKit
import WebKit

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

protocol WebViewViewControllerDelegate {
    func webViewViewController(didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    //MARK: - IB Outlets
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    
    //MARK: - Public properties
    var delegate: WebViewViewControllerDelegate?
    
    //MARK: - Privates properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
        estimatedProgressObservation = webView.observe(\.estimatedProgress,
                         options: [],
                         changeHandler: { [weak self] _,_  in
            guard let self = self else { return }
            self.updateProgress()
        })
    }
    
    //MARK: - IB Actions
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

private extension WebViewViewController {
    //MARK: - Privates Methods
    func loadWebView() {
        webView.navigationDelegate = self
        
        guard var urlComponents = URLComponents(string: UnsplashAuthorizeURLString) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        if let url = urlComponents.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

//MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = fetchCode(url: navigationAction.request.url) {
            delegate?.webViewViewController(didAuthenticateWithCode: code)
            delegate?.webViewViewControllerDidCancel(self)
            
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func fetchCode(url: URL?) -> String? {
        guard let url = url,
              let components = URLComponents(string: url.absoluteString),
              components.path == "/oauth/authorize/native",
              let codeItem = components.queryItems?.first(where: { $0.name == "code" }) else { return nil }
        
        return codeItem.value
    }
}
