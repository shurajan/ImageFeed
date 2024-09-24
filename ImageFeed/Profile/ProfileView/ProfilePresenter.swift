//
//  ProfileViewPOresenter.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 13.09.2024.
//

import UIKit

public protocol ProfilePresenterProtocol{
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func didPressLogOut()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let profileLogoutService: ProfileLogoutServiceProtocol

    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared, 
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
         profileLogoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
    }
    
    func viewDidLoad() {
        Log.info(message: "Loading profile data")
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard 
                    let self,
                    let view = self.view
                else { return }
                view.updateAvatar(profileImageURL: profileImageService.avatarURL)
            }
        
        view?.updateAvatar(profileImageURL: profileImageService.avatarURL)
        
        if let profile = profileService.profile {
            view?.updateProfileDetails(name: profile.name, loginName: profile.loginName, description: profile.bio)
        }
    }
    
    func didPressLogOut(){
        profileLogoutService.logout()
    }
}
