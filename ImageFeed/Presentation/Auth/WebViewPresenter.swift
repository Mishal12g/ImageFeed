//
//  WebViewProtocol.swift
//  ImageFeed
//
//  Created by mihail on 22.12.2023.
//

import Foundation

protocol WebViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
    var view: WebViewViewControllerProtocol? { get set }
}

final class WebViewPresenter: WebViewPresenterProtocol {
    //MARK: - Public properties
    private let authHelper: AuthHelperProtocol
    weak var view: WebViewViewControllerProtocol?
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    //MARK: - Public methods
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newValue: newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHindden(shouldHideProgress)
    }
    
    func viewDidLoad() {
        if let request = authHelper.authRequest() {
            view?.load(request: request)
            didUpdateProgressValue(0)
        }
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    //MARK: - Privates methods
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
