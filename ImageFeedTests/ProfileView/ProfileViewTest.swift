//
//  ProfileViewTest.swift
//  ImageFeedTests
//
//  Created by Alexander Bralnin on 16.09.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let presenter = ProfileViewPreseneterSpy()
        let view = ProfileViewController()
        view.configure(presenter)
        
        //when
        _ = view.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
        
    }
    
    func testProfileViewPresenter() {
        //given
        let profileService = MockProfileService()
        let profileImageService = MockProfileImageService()
        let presenter = ProfileViewPresenter(profileService: profileService, profileImageService: profileImageService)
        let view = ProfileViewControllerSpy()
        view.configure(presenter)
        
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertEqual(view.loginName, "@login", "Failed to set login")
        XCTAssertEqual(view.name, "first_name last_name", "Failed to set name")
        XCTAssertEqual(view.description, "description", "Failed to set description")
        XCTAssertEqual(view.profileImageURL, "some.url", "Failed to avatar url")
        
    }
    
}
