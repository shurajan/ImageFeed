//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 30.07.2024.
//

import UIKit
import SwiftKeychainWrapper

//MARK: - Protocols
protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

//MARK: - SplashViewController
final class SplashViewController: LightStatusBarViewController {
    
    // MARK: - UI Controls
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .ypBlackIOS
        view.image = UIImage(named: "vector")
        
        return view
    }()
    
    // MARK: - Private Variables
    private var isAuthenticated = false
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        drawSelf()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isAuthenticated {
            return
        }
        
        if let token = OAuth2TokenStorage.shared.token {
            fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            if let authViewController = storyboard.instantiateViewController(
                withIdentifier: "AuthViewController"
            ) as? AuthViewController {
                authViewController.delegate = self
                authViewController.modalPresentationStyle = .fullScreen
                present(authViewController, animated: true, completion: nil)
            } else {
                Log.warn(message: "Can not create Auth Controller")
            }
        }
    }
    
    // MARK: - Private functions
    private func drawSelf(){
        view.backgroundColor = UIColor.ypBlackIOS
        addView(logoImageView)
        addConstraints()
    }
    
    private func addConstraints(){
        let constraints = [logoImageView.widthAnchor.constraint(equalToConstant: 72),
                           logoImageView.heightAnchor.constraint(equalToConstant: 75),
                           logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                           logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            let message = "Invalid window configuration"
            Log.warn(message: message)
            assertionFailure(message)
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile(token) {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else {return}
            
            switch result{
            case .success(_):
                self.switchToTabBarController()
                ProfileImageService.shared.fetchProfileImageURL(token) {result in
                    switch result{
                    case .success(let avatarURL):
                        Log.info(message: avatarURL)
                    case .failure(let error):
                        Log.error(error: error)
                    }
                }
            case .failure(let error):
                Log.error(error: error, message: "Can not load profile for token")
            }
        }
        
    }
}

// MARK: - AuthViewControllerDelegate Extension
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        self.isAuthenticated = true
        vc.dismiss(animated: true)
        
        guard let token = OAuth2TokenStorage.shared.token else {
            return
        }
        
        fetchProfile(token: token)
    }
}
