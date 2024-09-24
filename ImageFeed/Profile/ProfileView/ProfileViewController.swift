//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 16.07.2024.
//


import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    func configure(_ presenter: ProfilePresenterProtocol)
    func updateProfileDetails(name: String, loginName: String, description: String)
    func updateAvatar(profileImageURL: String?)
}

final class ProfileViewController: LightStatusBarViewController {
    private var presenter: ProfilePresenterProtocol?
    
    // MARK: - UI Controls
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "stub")
        view.backgroundColor = .ypBlackIOS
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 35
        return view
    }()
    
    private lazy var exitButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "exit"), for: UIControl.State.normal)
        view.addTarget(self, action: #selector(exitButtonTapped(_:)), for: .touchUpInside)
        view.accessibilityIdentifier = "exitButton"
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
    private var alertPresenter: AlertPresenter?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        drawSelf()
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
    }
    
    //MARK: - View Layout methods
    private func drawSelf(){
        view.backgroundColor = UIColor.ypBlackIOS
        
        addViews()
        addConstraints()
        presenter?.viewDidLoad()
    }
    
    private func addViews(){
        addView(avatarImageView)
        addView(exitButton)
        addView(nameLabel)
        addView(loginNameLabel)
        addView(descriptionLabel)
    }
        
    private func addConstraints(){
        let constraints = [avatarImageView.widthAnchor.constraint(equalToConstant: 70),
                           avatarImageView.heightAnchor.constraint(equalToConstant: 70),
                           avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                           avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                           
                           exitButton.widthAnchor.constraint(equalToConstant: 44),
                           exitButton.heightAnchor.constraint(equalToConstant: 44),
                           exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
                           exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
                           
                           nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
                           nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
                           nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
                           nameLabel.heightAnchor.constraint(equalToConstant: 18),
                           
                           loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                           loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
                           loginNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
                           loginNameLabel.heightAnchor.constraint(equalToConstant: 18),
                           
                           descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
                           descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
                           descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
                           descriptionLabel.heightAnchor.constraint(equalToConstant: 18)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func logOut(){
        guard let window = UIApplication.shared.windows.first else {
            Log.warn(message: "Incorrect configuration")
            fatalError("Incorrect configuration")
        }
        presenter?.didPressLogOut()
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
    
    
    //MARK: - Private methods
    @IBAction private func exitButtonTapped(_ sender: UIButton) {
        
        let buttonYes = AlertButton(buttonText: "Да", style: .default) { [weak self] in
            guard let self = self
            else {return}
            Log.info(message: "Logging out")
            self.logOut()
        }
        
        let buttonNo = AlertButton(buttonText: "Нет", style: .default) { 
            Log.info(message: "Staying authenticated")
        }
        
        let alertModel = AlertModel(id: "exitAlert",
                                    title: "Пока, пока!",
                                    message: "Уверены что хотите выйти?",
                                    buttons: [buttonYes, buttonNo])
        
        self.alertPresenter?.showAlert(alertModel)

    }
}

//MARK: - ProfileViewControllerProtocol implementation
extension ProfileViewController: ProfileViewControllerProtocol {
    func configure(_ presenter: ProfilePresenterProtocol){
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func updateProfileDetails(name: String, loginName: String, description: String){
        Log.info(message: "updating profile details")
        nameLabel.text = name
        loginNameLabel.text = loginName
        descriptionLabel.text = description
    }

    func updateAvatar(profileImageURL: String?) {
        guard
            let profileImageURL,
            let url = URL(string: profileImageURL)
        else {
            Log.warn(message: "Can not load avatar image")
            return
        }
        
        let cache = ImageCache.default
        cache.clearDiskCache()
        avatarImageView.kf.indicatorType = .activity
        let roundCornerProcessor =  RoundCornerImageProcessor(cornerRadius: 42)
        
        avatarImageView.kf.setImage(with: url,
                                    placeholder: UIImage(named: "stub"),
                                    options: [.processor(roundCornerProcessor)])
    }
}
