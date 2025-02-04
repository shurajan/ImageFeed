//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 12.08.2024.
//

import Foundation

//MARK: - ProfileImageService Error
enum ProfileImageServiceError: Error {
    case invalidRequest
    
    var description: String? {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        }
    }
}

//MARK: - ProfileImageServiceProtocol

public protocol ProfileImageServiceProtocol {
    var avatarURL: String? { get }
    func fetchProfileImageURL(_ token: String, completion: @escaping (Result<String, Error>) -> Void)
}

//MARK: - ProfileImageService class
final class ProfileImageService: ProfileImageServiceProtocol {
    static let shared = ProfileImageService()
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    //MARK: - Dependency injections and constants
    private let username = ProfileService.shared.profile?.username
    private let urlSession = URLSession.shared
    private let baseURL = AuthConfiguration.standard.defaultBaseURL
    
    //MARK: - Private variables
    private var task: URLSessionTask?
        
    //MARK: - ProfileImageServiceProtocol protocol implementation
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(_ token: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        //Cancel the task
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeUserProfileRequest(for: token) else {
            let error = ProfileImageServiceError.invalidRequest
            Log.error(error: error, message: error.description)
            completion(.failure(error))
            
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            assert(Thread.isMainThread)
            switch result {
            case .success(let response):
                let avatarURL = response.profileImage.large
                self?.avatarURL = avatarURL
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                completion(.success(avatarURL))
            case .failure(let error):
                Log.error(error: error)
                completion(.failure(error))
            }
            self?.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    //MARK: - Private functions
    private func makeUserProfileURL(from baseURL :URL, for username: String) -> URL {
        if #available(iOS 16, *) {
            return baseURL
                .appending(path: "users")
                .appending(path: username)
        }
        else {
            return baseURL
                .appendingPathComponent("users")
                .appendingPathComponent(username)
        }
    }
    
    private func makeUserProfileRequest(for token: String) -> URLRequest? {
        guard let baseURL,
              let username
        else {
            let message = "Can not build url request"
            Log.warn(message: message)
            assertionFailure(message)
            return nil
        }
        
        let profileURL = makeUserProfileURL(from: baseURL, for: username)
        var request = URLRequest(url: profileURL)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
}

extension ProfileImageService: ProfileCleanProtocol {
    
    func clean(){
        if task != nil {
            task?.cancel()
        }
        task = nil
        avatarURL = nil
    }
}
