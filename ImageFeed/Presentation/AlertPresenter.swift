//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by mihail on 29.11.2023.
//

import UIKit

protocol AlertPresenterProtocol {
    func show(model: AlertModel?)
    func showTwoAction(model: AlertModel?)
}

protocol AlertDelegate: AnyObject {
    func show(model: AlertModel?)
}

final class AlertPresenter {
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
}

extension AlertPresenter: AlertDelegate, AlertPresenterProtocol {
    func showTwoAction(model: AlertModel?) {
        guard let model = model else { return }
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText,
                                   style: .default) { _ in
            model.completion()
        }
        
        let actionTwo = UIAlertAction(title: model.buttonText2,
                                      style: .default)
        alert.addAction(action)
        alert.addAction(actionTwo)
        delegate?.present(alert, animated: true)
    }
    
    func show(model: AlertModel?) {
        guard let model = model else { return }
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText,
                                   style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        delegate?.present(alert, animated: true)
    }
}
