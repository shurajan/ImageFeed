//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 16.07.2024.
//


import UIKit

final class ProfileViewController: BasicViewController {
   
    // MARK: - UI Controls
    private var profileImageView: UIImageView!
    private var exitButton: UIButton!
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    

    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ypBlackIOS
        
        var constraints = placeProfileImageAndGetConstraints()
        constraints += placeExitButtonImageAndGetConstraints()
        constraints += placeNameLabelAndGetConstraints()
        constraints += placeLoginNameLabelAndGetConstraints()
        constraints += placeDescriptionLabelAndGetConstraints()
                        
        NSLayoutConstraint.activate(constraints)
        
    }

    //MARK: - View Layout methods
    private func addControl(_ newControl: UIView) {
        newControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newControl)
    }
    
    private func placeProfileImageAndGetConstraints() -> [NSLayoutConstraint] {
        let profileImage = UIImage(named: "avatar")
        profileImageView = UIImageView(image: profileImage)
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
        nameLabel.text = "Екатерина Новикова"
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
        loginNameLabel.text = "@ekaterina_nov"
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
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.textColor = UIColor.ypWhiteIOS
        addControl(descriptionLabel)
        
        return[descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
               descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
               descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
               descriptionLabel.heightAnchor.constraint(equalToConstant: 18)
        ]
    }
    
    
    
}
    
