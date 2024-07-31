//
//  Constants.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 25.07.2024.
//

import Foundation

enum URLConstants {
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let tokenURLString = "https://unsplash.com/oauth/token"
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
}

enum Constants {
    static let accessKey = "chj14e1HSFftw2dK3yyG0Y9OKDDmnjlz6sV5vCWjJ_4"
    static let secretKey = "sjgVAUywQnRVYNuy2n4An3xrknWRkoP7LcBqyeDZluY"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
}

