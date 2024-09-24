//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Alexander Bralnin on 16.09.2024.
//


import Foundation
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var name: String = ""
    var loginName = ""
    var description = ""
    var profileImageURL = ""
    
    private var presenter: ProfilePresenterProtocol?
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func updateProfileDetails(name: String, loginName: String, description: String) {
        self.name = name
        self.loginName = loginName
        self.description = description
    }
    
    func updateAvatar(profileImageURL: String?) {
        self.profileImageURL = profileImageURL ?? "fail"
    }
    
    
}
