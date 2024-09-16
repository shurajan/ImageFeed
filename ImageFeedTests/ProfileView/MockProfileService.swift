//
//  MockProfileService.swift
//  ImageFeedTests
//
//  Created by Alexander Bralnin on 16.09.2024.
//

import Foundation
@testable import ImageFeed

final class MockProfileService: ProfileServiceProtocol {
    var profile: Profile?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    init() {
        let response = ProfileResult(username: "login", firstName: "first_name", lastName: "last_name", bio: "description")
        self.profile = Profile(from: response)
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, any Error>) -> Void) {
    }
    
    
}
