//
//  DarkStatusBarViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 31.07.2024.
//

import UIKit

class DarkStatusBarViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}
