//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 09.08.2024.
//

import Foundation

//MARK: - ProfileService Error
enum ProfileServiceError: Error {
    case invalidRequest
    
    var description: String? {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        }
    }
}

//MARK: - ProfileService class
final class ProfileService {
    static let shared = ProfileService()
    
    //MARK: - Dependency injections and constants
    private let urlSession = URLSession.shared
    private let baseURL = AuthConfiguration.standard.defaultBaseURL
    
    //MARK: - Private(set) variables
    private(set) var profile: Profile?
    
    //MARK: - Private variables
    private var task: URLSessionTask?
    
    //MARK: - Public functions
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        //Cancel the task
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeProfileRequest(for: token) else {
            let error = ProfileServiceError.invalidRequest
            Log.error(error: error, message: error.description)
            completion(.failure(error))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            assert(Thread.isMainThread)
            switch result {
            case .success(let response):
                let profile = Profile(from: response)
                self?.profile = profile
                completion(.success(profile))
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
    private func makeProfileURL(from baseURL :URL) -> URL {
        if #available(iOS 16, *) {
            return baseURL.appending(path: "me")
        }
        else {
            return baseURL.appendingPathComponent("me")
        }
    }
    
    private func makeProfileRequest(for token: String) -> URLRequest? {
        
        guard let baseURL
        else {
            let message = "Can not build url request"
            Log.warn(message: message)
            assertionFailure(message)
            return nil
        }
        
        let profileURL = makeProfileURL(from: baseURL)
        var request = URLRequest(url: profileURL)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
}

extension ProfileService: ProfileCleanProtocol {
    func clean() {
        if task != nil {
            task?.cancel()
        }
        task = nil
        profile = nil
    }
}
