//
//  MockProfileImageService.swift
//  ImageFeedTests
//
//  Created by Alexander Bralnin on 16.09.2024.
//


import Foundation
@testable import ImageFeed


final class MockProfileImageService: ProfileImageServiceProtocol {
    var avatarURL: String? = "some.url"
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(_ token: String, completion: @escaping (Result<String, any Error>) -> Void) {
        
    }
    
    
}
