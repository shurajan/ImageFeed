//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 30.07.2024.
//

import UIKit

//MARK: - Protocols
protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

//MARK: - SplashViewController
final class SplashViewController: LightStatusBarViewController {
    private let showAuthViewSegueIdentifier = "ShowAuthView"
    
    //MARK: - View Life Cycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage.shared.token {
            fetchProfile(token: token)
        } else {
            performSegue(withIdentifier:  showAuthViewSegueIdentifier, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthViewSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthViewSegueIdentifier)")
                print("Failed to prepare for \(showAuthViewSegueIdentifier)")
                return
            }
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private functions
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            print("Invalid window configuration")
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
                        print(avatarURL)
                    case .failure(let error):
                        print("Can not load profile image for token : \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Can not load profile for token : \(error.localizedDescription)")
            }
        }
        
    }
}

// MARK: - AuthViewControllerDelegate Extension
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = OAuth2TokenStorage.shared.token else {
            return
        }
        
        fetchProfile(token: token)
    }
}
