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
    
    static let domainName = "https://unsplash.com"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let tokenURLString = "https://unsplash.com/oauth/token"
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
    
    static let codeItemName = "code"
    static let codePath = "/oauth/authorize/native"
}

struct AuthConfiguration {
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            domainName: Constants.domainName,
            defaultBaseURL: Constants.defaultBaseURL,
            tokenURLString: Constants.tokenURLString,
            authorizeURLString: Constants.authorizeURLString,
            codeItemName: Constants.codeItemName,
            codePath: Constants.codePath
        )
    }
    
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let domainName: String
    let defaultBaseURL: URL?
    let tokenURLString: String
    let authorizeURLString: String
    let codeItemName: String
    let codePath: String
}
