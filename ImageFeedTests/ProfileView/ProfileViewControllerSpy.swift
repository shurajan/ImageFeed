//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Alexander Bralnin on 16.09.2024.
//


import Foundation
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    private var presenter: ProfileViewPresenterProtocol?
    
    func configure(_ presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    var name: String = ""
    var loginName = ""
    var description = ""
    var profileImageURL = ""
    
    func updateProfileDetails(name: String, loginName: String, description: String) {
        self.name = name
        self.loginName = loginName
        self.description = description
    }
    
    func updateAvatar(profileImageURL: String?) {
        self.profileImageURL = profileImageURL ?? "fail"
    }
    
    
}
