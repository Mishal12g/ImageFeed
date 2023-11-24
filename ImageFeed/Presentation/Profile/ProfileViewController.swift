//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by mihail on 20.10.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService()
    private let tokenStorage = OAuth2TokenStorage()
    
    //MARK: - Privates methods
    private let mailLabel: UILabel = {
        let Label = UILabel()
        Label.translatesAutoresizingMaskIntoConstraints = false
        Label.textColor = .ypGray
        Label.font = UIFont.systemFont(ofSize: 13)
        
        return Label
    }()
    
    private let avatarImage: UIImageView = {
        let avatar = UIImage(named: "avatar")
        let avatarImage = UIImageView(image: avatar)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        return avatarImage
    }()
    
    private let exitButton: UIButton = {
        let imageButton = UIImage(systemName: "ipad.and.arrow.forward")
        let button = UIButton.systemButton(with: imageButton ?? UIImage(), target: self, action: #selector(onExitButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypRed
        
        return button
    }()
    
    private let fullName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23)
        
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        
        return label
    }()
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        applyConstraints()
        profileService.fetchProfile(token: tokenStorage.token ?? "") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                self.fullName.text = profile.name
                self.statusLabel.text = profile.bio
                self.mailLabel.text = profile.loginName
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - Privates methods
    private func addSubviews(){
        view.addSubview(mailLabel)
        view.addSubview(avatarImage)
        view.addSubview(fullName)
        view.addSubview(statusLabel)
        view.addSubview(exitButton)
        
    }
    
    private func applyConstraints() {
        //MARK: - Constraints settings
        NSLayoutConstraint.activate([
            //Avatar image
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            //Exit button
            exitButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            exitButton.widthAnchor.constraint(equalToConstant: 20),
            exitButton.heightAnchor.constraint(equalToConstant: 22),
            //Full name
            fullName.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            fullName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            fullName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            //Mail label
            mailLabel.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 8),
            mailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            //Status label
            statusLabel.topAnchor.constraint(equalTo: mailLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func onExitButton() {
        
    }
}
