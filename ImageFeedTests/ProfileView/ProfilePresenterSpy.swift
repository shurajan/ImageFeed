//
//  ProfileViewPreseneterSpy.swift
//  ImageFeedTests
//
//  Created by Alexander Bralnin on 16.09.2024.
//

import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    var didPressLogOutCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didPressLogOut() {
        didPressLogOutCalled = true
    }
    
}
