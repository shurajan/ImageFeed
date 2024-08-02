//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 29.07.2024.
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

//MARK: - OAuth2Service
final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private init() {
    }
    
    private func makeOAuthTokenRequest(for code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: URLConstants.tokenURLString) else {
            assertionFailure("Can not build url components")
            print("Can not build url components")
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
            assertionFailure("Can not build url")
            print("Can not build url")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
    
    func fetchOAuthToken(for code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(for: code) else {return}
        
        let task = URLSession.shared.data(for: request) { result in
            switch result{
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(response.accessToken))
                } catch {
                    print("Can not decode response from unsplash: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}



