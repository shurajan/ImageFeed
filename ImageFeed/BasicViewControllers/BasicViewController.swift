//
//  BasicViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 23.08.2024.
//

import UIKit


class BasicViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}

//MARK: - Add new view to viewcontroller
extension BasicViewController {
    internal final func addView(_ newControl: UIView) {
        newControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newControl)
    }
}
