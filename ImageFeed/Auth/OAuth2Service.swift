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

protocol OAuth2ServiceProtocol {
    func fetchOAuthToken(for code: String, completion: @escaping (Result<String, Error>) -> Void)
}

//MARK: - OAuth2Service
final class OAuth2Service: OAuth2ServiceProtocol {
    static let shared = OAuth2Service()
    //MARK: - Dependency injections and constants
    private let urlSession = URLSession.shared
    
    //MARK: - Private variables
    private var task: URLSessionTask?
    private var lastCode: String?
    
    //MARK: - Public functions
    func fetchOAuthToken(for code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                let error = AuthServiceError.duplicateRequest
                Log.error(error: error, message: error.description)
                completion(.failure(error))
                return
            }
        } else if lastCode == code {
            let error = AuthServiceError.authTokenAlreadyObtained
            Log.error(error: error, message: error.description)
            completion(.failure(error))
            return
        }
        
        lastCode = code
        guard let request = makeOAuthTokenRequest(for: code) else {
            let error = AuthServiceError.invalidRequest
            Log.error(error: error, message: error.description)
            completion(.failure(error))
            
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            assert(Thread.isMainThread)
            switch result {
            case .success(let response):
                completion(.success(response.accessToken))
            case .failure(let error):
                Log.error(error: error)
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
        guard var urlComponents = URLComponents(string: AuthConfiguration.standard.tokenURLString) else {
            let message = "Can not build url components"
            Log.warn(message: message)
            assertionFailure(message)
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AuthConfiguration.standard.accessKey),
            URLQueryItem(name: "client_secret", value: AuthConfiguration.standard.secretKey),
            URLQueryItem(name: "redirect_uri", value: AuthConfiguration.standard.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            let message = "Can not build url"
            Log.warn(message: message)
            assertionFailure(message)
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }

}

extension OAuth2Service: ProfileCleanProtocol {
    func clean(){
        if task != nil {
            task?.cancel()
        }
        task = nil
        lastCode = nil
        
    }
}


