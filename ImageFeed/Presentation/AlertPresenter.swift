//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by mihail on 29.11.2023.
//

import UIKit

protocol AlertPresenterProtocol {
    static func show(model: AlertModel?,  controller: UIViewController)
    static func showTwoAction(model: AlertModel?, controller: UIViewController)
}

final class AlertPresenter: AlertPresenterProtocol {
    static func showTwoAction(model: AlertModel?,  controller: UIViewController) {
        guard let model = model else { return }
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "bye bye"
        let action = UIAlertAction(title: model.buttonText,
                                   style: .default) { _ in
            model.completion()
        }
        action.accessibilityIdentifier = "Yes"
        let actionTwo = UIAlertAction(title: model.buttonText2,
                                      style: .default)
        alert.addAction(action)
        alert.addAction(actionTwo)
        controller.present(alert, animated: true)
    }
    
    static func show(model: AlertModel?,  controller: UIViewController) {
        guard let model = model else { return }
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText,
                                   style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
}
