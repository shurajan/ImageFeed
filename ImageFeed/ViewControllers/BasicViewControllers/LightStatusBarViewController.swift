//
//  BasicViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 22.07.2024.
//

import UIKit

class LightStatusBarViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}
