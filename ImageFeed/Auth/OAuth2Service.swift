//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 29.07.2024.
//

import Foundation

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

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let networkService: NetworkRouting
    
    private init() {
        networkService = NetworkService()
    }
    
    private func makeOAuthTokenRequest(for code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: UnsplashURLConstants.tokenURLString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
    
    func fetchOAuthToken(for code: String, handler: @escaping (Result<Data, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(for: code) else {return}
        let task = URLSession.shared.data(for: request, handler: handler)
        task.resume()
        
    }
}



