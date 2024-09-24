//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 22.08.2024.
//

import UIKit

final class TabBarController: UITabBarController {

    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let profileViewPresenter = ProfilePresenter()
        let profileViewController = ProfileViewController()
        profileViewController.configure(profileViewPresenter)
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        let imageListViewPresenter = ImageListPresenter()
        if let imageListViewController: ImageListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImageListViewController"
        ) as? ImageListViewController {
            imageListViewController.configure(imageListViewPresenter)
            self.viewControllers = [imageListViewController, profileViewController]
        } else {
            Log.warn(message: "Can not instantiate ImageListViewController")
            self.viewControllers = [profileViewController]
        }
        
    }
}
