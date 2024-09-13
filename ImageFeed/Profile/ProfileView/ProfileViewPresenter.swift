//
//  ProfileViewPOresenter.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 13.09.2024.
//

import Foundation

public protocol ProfileViewPresenterProtocol{
    var view: ProfileViewControllerProtocol? { get set }
    
    func addProfileImageServiceObserver()
    func updateProfileDetails()
    func updateAvatar()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?

    private var profileImageServiceObserver: NSObjectProtocol?
    
    func addProfileImageServiceObserver() {
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
                view.updateAvatar(profileImageURL: ProfileImageService.shared.avatarURL)
            }
        
        view?.updateAvatar(profileImageURL: ProfileImageService.shared.avatarURL)
    }
    
    func updateProfileDetails() {
        if let profile = ProfileService.shared.profile {
            view?.updateProfileDetails(name: profile.name, loginName: profile.loginName, description: profile.bio)
        }
    }
    
    func updateAvatar() {
        view?.updateAvatar(profileImageURL: ProfileImageService.shared.avatarURL)
    }
}
