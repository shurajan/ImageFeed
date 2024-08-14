//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 16.07.2024.
//


import UIKit
import Kingfisher

final class ProfileViewController: LightStatusBarViewController {
    
    // MARK: - UI Controls
    private var profileImageView: UIImageView!
    private var exitButton: UIButton!
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!

    // MARK: - Private Variables
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypBlackIOS
        
        var constraints = placeProfileImageAndGetConstraints()
        constraints += placeExitButtonImageAndGetConstraints()
        constraints += placeNameLabelAndGetConstraints()
        constraints += placeLoginNameLabelAndGetConstraints()
        constraints += placeDescriptionLabelAndGetConstraints()
        if let profile = ProfileService.shared.profile {
            updateProfileDetails(profile: profile)
        }
                        
        NSLayoutConstraint.activate(constraints)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }

    //MARK: - View Layout methods
    private func addControl(_ newControl: UIView) {
        newControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newControl)
    }
    
    private func placeProfileImageAndGetConstraints() -> [NSLayoutConstraint] {
        //let profileImage = UIImage(named: "avatar")
        profileImageView = UIImageView()
        addControl(profileImageView)
        
        return [profileImageView.widthAnchor.constraint(equalToConstant: 70),
                profileImageView.heightAnchor.constraint(equalToConstant: 70),
                profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ]
    }
    
    private func placeExitButtonImageAndGetConstraints() -> [NSLayoutConstraint] {
        let exitButtonImage = UIImage(named: "exit")
        exitButton = UIButton()
        exitButton.setImage(exitButtonImage, for: UIControl.State.normal)
        addControl(exitButton)
        
        return [exitButton.widthAnchor.constraint(equalToConstant: 44),
                exitButton.heightAnchor.constraint(equalToConstant: 44),
                exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
                exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4)
        ]
    }
    
    private func placeNameLabelAndGetConstraints()-> [NSLayoutConstraint] {
        nameLabel = UILabel()
        nameLabel.text = "unknown"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        nameLabel.textColor = UIColor.ypWhiteIOS
        addControl(nameLabel)
        
        return [nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
                nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
                nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
                nameLabel.heightAnchor.constraint(equalToConstant: 18)
        ]
    }
    
    private func placeLoginNameLabelAndGetConstraints()-> [NSLayoutConstraint] {
        loginNameLabel = UILabel()
        loginNameLabel.text = "unknown"
        loginNameLabel.font = UIFont.systemFont(ofSize: 18)
        loginNameLabel.textColor = UIColor.ypGrayIOS
        addControl(loginNameLabel)
        
        return[loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
               loginNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
               loginNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
               loginNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ]
    }
    
    private func placeDescriptionLabelAndGetConstraints()-> [NSLayoutConstraint] {
        descriptionLabel = UILabel()
        descriptionLabel.text = "not available"
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.textColor = UIColor.ypWhiteIOS
        descriptionLabel.numberOfLines = 0
        addControl(descriptionLabel)
        
        return[descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
               descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
               descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
               descriptionLabel.heightAnchor.constraint(equalToConstant: 18)
        ]
    }
    
    
    //MARK: - Private methods
    private func updateProfileDetails(profile: Profile){
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            Log.warn(message: "Can not load avatar image")
            return
        }
        profileImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: profileImageView.frame.width/2)
        profileImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "stub"),
                                     options: [.processor(processor)])
        
    }
    
}
    
