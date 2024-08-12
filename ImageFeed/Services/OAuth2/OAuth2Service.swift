//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 29.07.2024.
//

import Foundation

//MARK: - AuthService Error
enum AuthServiceError: Error {
    case invalidRequest, authTokenAlreadyObtained, duplicateRequest
    
    var description: String? {
        switch self {
        case .duplicateRequest:
            return "Request duplication"
        case .authTokenAlreadyObtained:
            return "Auth token already obtained"
        case .invalidRequest:
            return "Invalid request"
        }
    }
}

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
    
    //MARK: - Dependency injections and constants
    private let urlSession = URLSession.shared
    
    //MARK: - Private variables
    private var task: URLSessionTask?
    private var lastCode: String?
    
    //MARK: - Init
    private init() {
    }
    
    //MARK: - Public functions
    func fetchOAuthToken(for code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                print("Trying to send a new request for the same code")
                completion(.failure(AuthServiceError.duplicateRequest))
                return
            }
        } else if lastCode == code {
            print("Auth token already received")
            completion(.failure(AuthServiceError.authTokenAlreadyObtained))
            return
        }
        
        lastCode = code
        guard let request = makeOAuthTokenRequest(for: code) else {
            print("Can not make the request for code")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        //Handler запускается в main thread см Helpers\URLSession+data
        let task = urlSession.data(for: request) {[weak self] result in
            assert(Thread.isMainThread)
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
            self?.task = nil
            self?.lastCode = nil
        }
        self.task = task
        task.resume()
    }
    
    //MARK: - Private functions
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

}



