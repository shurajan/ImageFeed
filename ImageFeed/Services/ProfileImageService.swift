//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 12.08.2024.
//

import Foundation

//MARK: - ProfileService Error
enum ProfileImageServiceError: Error {
    case invalidRequest
    
    var description: String? {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        }
    }
}

struct UserResult: Codable{
    let profileImage: ProfileImage
    
    struct ProfileImage: Codable {
        let small: String
    }
    
    private enum CodingKeys : String, CodingKey {
        case profileImage = "profile_image"
    }
}

//MARK: - ProfileImageService class
final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    //MARK: - Dependency injections and constants
    private let username = ProfileService.shared.profile?.username
    private let urlSession = URLSession.shared
    private let baseURL = URLConstants.defaultBaseURL
    
    //MARK: - Private(set) variables
    private (set) var avatarURL: String?
    
    //MARK: - Private variables
    private var task: URLSessionTask?
    
    //MARK: - Init
    private init(){
    }
    
    //MARK: - Public functions
    func fetchProfileImageURL(_ token: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        //Cancel the task
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeUserProfileRequest(for: token) else {
            print("Can not make the request for token")
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            assert(Thread.isMainThread)
            switch result {
            case .success(let response):
                let avatarURL = response.profileImage.small
                self?.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                
            case .failure(let error):
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
            assertionFailure("Can not build url request")
            print("Can not build url request")
            return nil
        }
        
        let profileURL = makeUserProfileURL(from: baseURL, for: username)
        var request = URLRequest(url: profileURL)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
}
