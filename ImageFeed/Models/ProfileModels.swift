//
//  ProfileModels.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 23.08.2024.
//

import Foundation

//MARK: - ProfileResult struct
struct ProfileResult: Codable {
    let username : String
    let firstName: String
    let lastName : String?
    let bio      : String?
    
    private enum CodingKeys : String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

//MARK: - Profile struct
struct Profile {
    let username  : String
    let name      : String
    let loginName : String
    let bio       : String
    
    init(from response: ProfileResult) {
        if let lastName = response.lastName {
            self.name = "\(response.firstName) \(lastName)"
        } else {
            self.name = response.firstName
        }
        self.username = response.username
        self.loginName = "@\(response.username)"
        self.bio = response.bio ?? ""
    }
}

//MARK: - Profile struct for profile image
struct UserResult: Codable{
    let profileImage: ProfileImage
    
    struct ProfileImage: Codable {
        let small: String
    }
    
    private enum CodingKeys : String, CodingKey {
        case profileImage = "profile_image"
    }
}
