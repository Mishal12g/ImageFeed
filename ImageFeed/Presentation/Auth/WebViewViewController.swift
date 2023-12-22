//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by mihail on 08.11.2023.
//

import UIKit
import WebKit

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(newValue: Float)
    func setProgressHindden(_ isHidden: Bool)
}

protocol WebViewViewControllerDelegate {
    func webViewViewController(didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    
    //MARK: - IB Outlets
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    
    //MARK: - Public properties
    var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    //MARK: - Privates properties
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        progressView.progress = 0
        estimatedProgressObservation = webView.observe(\.estimatedProgress,
                                                        options: [],
                                                        changeHandler: { [weak self] _,_  in
            guard let self = self else { return }
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        })
    }
    
    //MARK: - IB Actions
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController {
    //MARK: - Privates Methods
    func setProgressValue(newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHindden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}

//MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           let code = presenter?.code(from: url) {
            delegate?.webViewViewController(didAuthenticateWithCode: code)
            delegate?.webViewViewControllerDidCancel(self)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
