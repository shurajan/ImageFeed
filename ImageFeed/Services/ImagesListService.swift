//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 01.09.2024.
//

import Foundation

//MARK: - AuthService Error
enum ImagesListServiceServiceError: Error {
    case invalidRequest, duplicateRequest
    
    var description: String? {
        switch self {
        case .duplicateRequest:
            return "Request duplication"
        case .invalidRequest:
            return "Invalid request"
        }
    }
}

final class ImagesListService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    private let baseURL = URLConstants.defaultBaseURL
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    //MARK: - Public functions
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        if task != nil {
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard
            let token = OAuth2TokenStorage.shared.token,
            let request = makeNextPageRequest(for: token, page: nextPage) else {
            let error = ImagesListServiceServiceError.invalidRequest
            Log.error(error: error, message: error.description)
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            assert(Thread.isMainThread)
            guard let self else {return}
            switch result {
            case .success(let result):
                self.appendNewPhotos(items: result)
            case .failure(let error):
                Log.error(error: error)
            }
            self.task = nil
        }
        
        NotificationCenter.default
            .post(
                name: ImagesListService.didChangeNotification,
                object: self,
                userInfo: ["URL": ""])
    }
    
    //MARK: - Private functions
    private func appendNewPhotos(items: [PhotoResult]){
        for photoResult in items {
            let newPhoto = Photo(from: photoResult)
            photos.append(newPhoto)
        }
    }
    
    private func makeNextPageRequest(for token: String, page: Int) -> URLRequest? {
        guard let baseURL,
              var urlComponents = URLComponents(url: makePhotosURL(from: baseURL), resolvingAgainstBaseURL: true)
        else {
            let message = "Can not build url components"
            Log.warn(message: message)
            assertionFailure(message)
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        guard let url = urlComponents.url else {
            let message = "Can not build url"
            Log.warn(message: message)
            assertionFailure(message)
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    private func makePhotosURL(from baseURL :URL) -> URL {
        if #available(iOS 16, *) {
            return baseURL.appending(path: "photos")
        }
        else {
            return baseURL.appendingPathComponent("photos")
        }
    }
    
    
}
