//
//  Constants.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 25.07.2024.
//

import Foundation

fileprivate enum Constants {
    static let accessKey = "chj14e1HSFftw2dK3yyG0Y9OKDDmnjlz6sV5vCWjJ_4"
    static let secretKey = "sjgVAUywQnRVYNuy2n4An3xrknWRkoP7LcBqyeDZluY"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let tokenURLString = "https://unsplash.com/oauth/token"
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
}


struct AuthConfiguration {
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 tokenURLString: Constants.tokenURLString,
                                 authorizeURLString: Constants.authorizeURLString
        )
    }
    
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL?
    let tokenURLString: String
    let authorizeURLString: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         defaultBaseURL: URL?,
         tokenURLString: String,
         authorizeURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.tokenURLString = tokenURLString
        self.authorizeURLString = authorizeURLString
    }
}
