//
//  OAuthTokenResponseModel.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 23.08.2024.
//

import Foundation

//MARK: - OAuthTokenResponseBody struct
struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Date
    
    private enum CodingKeys : String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
    }
}
