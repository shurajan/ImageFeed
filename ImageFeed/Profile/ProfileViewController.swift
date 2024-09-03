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
    private lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "stub")
        view.backgroundColor = .ypBlackIOS
        return view
    }()
    
    private lazy var exitButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "exit"), for: UIControl.State.normal)
        view.addTarget(self, action: #selector(exitButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.text = "unknown"
        view.font = UIFont.boldSystemFont(ofSize: 23)
        view.addCharacterSpacing(kernValue: -0.08)
        view.textColor = UIColor.ypWhiteIOS
        return view
    } ()
    
    private var loginNameLabel: UILabel = {
        let view = UILabel()
        view.text = "@unknown"
        view.font = UIFont.systemFont(ofSize: 13)
        view.textColor = UIColor.ypGrayIOS
        return view
    } ()
    
    private var descriptionLabel: UILabel = {
        let view = UILabel()
        view.text = "not available"
        view.font = UIFont.systemFont(ofSize: 13)
        view.textColor = UIColor.ypWhiteIOS
        view.numberOfLines = 0
        return view
    } ()
    
    // MARK: - Private Variables
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        drawSelf()
    }
    
    //MARK: - View Layout methods
    private func drawSelf(){
        view.backgroundColor = UIColor.ypBlackIOS
        
        addViews()
        addConstraints()
        if let profile = ProfileService.shared.profile {
            updateProfileDetails(profile: profile)
        }
        
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
    
    private func addViews(){
        addView(profileImageView)
        addView(exitButton)
        addView(nameLabel)
        addView(loginNameLabel)
        addView(descriptionLabel)
    }
        
    private func addConstraints(){
        let constraints = [profileImageView.widthAnchor.constraint(equalToConstant: 70),
                           profileImageView.heightAnchor.constraint(equalToConstant: 70),
                           profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                           profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                           
                           exitButton.widthAnchor.constraint(equalToConstant: 44),
                           exitButton.heightAnchor.constraint(equalToConstant: 44),
                           exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
                           exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
                           
                           nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
                           nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
                           nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
                           nameLabel.heightAnchor.constraint(equalToConstant: 18),
                           
                           loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                           loginNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
                           loginNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
                           loginNameLabel.heightAnchor.constraint(equalToConstant: 18),
                           
                           descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
                           descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
                           descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
                           descriptionLabel.heightAnchor.constraint(equalToConstant: 18)
        ]
        NSLayoutConstraint.activate(constraints)
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
        let cache = ImageCache.default
        cache.clearDiskCache()
        profileImageView.kf.indicatorType = .activity
        let roundCornerProcessor =  RoundCornerImageProcessor(cornerRadius: 35)
        
        profileImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "stub"),
                                     options: [.processor(roundCornerProcessor)])
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        Log.info(message: "Logging out")
    }
}

