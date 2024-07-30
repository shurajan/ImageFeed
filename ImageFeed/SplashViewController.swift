//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 30.07.2024.
//

import UIKit

enum SegueNames {
    static let showImageListSegueIdentifier = "ShowImageListView"
    static let showAuthViewSegueIdentifier = "ShowAuthView"
}

final class SplashViewController: BasicViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage.shared.token {
            performSegue(withIdentifier: SegueNames.showImageListSegueIdentifier, sender: self)
        } else {
            performSegue(withIdentifier:  SegueNames.showAuthViewSegueIdentifier, sender: self)
        }
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueNames.showAuthViewSegueIdentifier {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(SegueNames.showAuthViewSegueIdentifier)")
                return
            }
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        performSegue(withIdentifier:  SegueNames.showImageListSegueIdentifier, sender: self)
    }
    
    
}
