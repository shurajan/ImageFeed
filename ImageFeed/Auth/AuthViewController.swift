//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 25.07.2024.
//

import UIKit

final class AuthViewController: BasicViewController {
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    //MARK: - Private Functions
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlackIOS
    }
}
