//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by mihail on 20.10.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    //MARK: - Privates methods
    private func viewSetup() {
        //AvatarImage
        let avatar = UIImage(named: "avatar")
        let avatarImage = UIImageView(image: avatar)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImage)
        
        //ExitButton
        let imageButton = UIImage(systemName: "ipad.and.arrow.forward")
        let exitButton = UIButton.systemButton(with: imageButton ?? UIImage(), target: self, action: #selector(self.onExitButton))
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        exitButton.tintColor = .ypRed
        
        //FullName
        let fullName = UILabel()
        fullName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fullName)
        
        fullName.text = "Екатерина Новикова"
        fullName.textColor = .ypWhite
        fullName.font = UIFont.boldSystemFont(ofSize: 23)
        
        //MailLabel
        let mailLabel = UILabel()
        mailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mailLabel)
        
        mailLabel.text = "@ekaterina_nov"
        mailLabel.textColor = .ypGray
        mailLabel.font = UIFont.systemFont(ofSize: 13)
        
        //StatusLamel
        let statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        statusLabel.text = "Hello, world!"
        statusLabel.textColor = .ypWhite
        statusLabel.font = UIFont.systemFont(ofSize: 13)
        
        //MARK: - Constraints settings
        NSLayoutConstraint.activate([avatarImage.heightAnchor.constraint(equalToConstant: 70),
                                     avatarImage.widthAnchor.constraint(equalToConstant: 70),
                                     avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
                                     avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                                     exitButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
                                     exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
                                     exitButton.widthAnchor.constraint(equalToConstant: 20),
                                     exitButton.heightAnchor.constraint(equalToConstant: 22),
                                     fullName.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
                                     fullName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                                     mailLabel.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 8),
                                     mailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                                     statusLabel.topAnchor.constraint(equalTo: mailLabel.bottomAnchor, constant: 8),
                                     statusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
                                    ])
    }
    
    @objc private func onExitButton() {
        
    }
}
