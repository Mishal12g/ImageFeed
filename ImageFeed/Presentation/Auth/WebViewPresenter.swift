//
//  WebViewProtocol.swift
//  ImageFeed
//
//  Created by mihail on 22.12.2023.
//

import Foundation

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

protocol WebViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
    var view: WebViewViewControllerProtocol? { get set }
}

final class WebViewPresenter: WebViewPresenterProtocol {
    //MARK: - Public properties
    weak var view: WebViewViewControllerProtocol?
    
    //MARK: - Public methods
    func code(from url: URL) -> String? {
        guard let components = URLComponents(string: url.absoluteString),
              components.path == "/oauth/authorize/native",
              let codeItem = components.queryItems?.first(where: { $0.name == "code" }) else { return nil }
        
        return codeItem.value
        
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newValue: newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHindden(shouldHideProgress)
    }
    
    func viewDidLoad() {
        guard var urlComponents = URLComponents(string: UnsplashAuthorizeURLString) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        
        didUpdateProgressValue(0)
        
        if let url = urlComponents.url {
            let request = URLRequest(url: url)
            view?.load(request: request)
        }
    }
    
    //MARK: - Privates methods
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
