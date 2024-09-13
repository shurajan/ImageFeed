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

//MARK: - ImagesListService
final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    private let baseURL = AuthConfiguration.standard.defaultBaseURL
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var loadPhotosTask: URLSessionTask?
    private var changeLikeTask: URLSessionTask?
    
    //MARK: - Public functions
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        if loadPhotosTask != nil {
            Log.info(message: "Task is in progress")
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
            
            NotificationCenter.default
                .post(
                    name: ImagesListService.didChangeNotification,
                    object: self)
            
            self.loadPhotosTask = nil
            lastLoadedPage = nextPage
        }
        
        self.loadPhotosTask = task
        task.resume()
    }
    
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void?, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if changeLikeTask != nil {
            Log.info(message: "Already sent like change request")
            return
        }
        
        guard
            let token = OAuth2TokenStorage.shared.token,
            let request = makeLikeChangeRequest(for: token, photoId: photoId, isLike: isLike) else {
            let error = ImagesListServiceServiceError.invalidRequest
            Log.error(error: error, message: error.description)
            completion(.failure(error))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoLikeChangeResult, Error>) in
            assert(Thread.isMainThread)
            guard let self else {return}
            switch result {
            case .success(let result):
                let newPhoto = Photo(from: result.photo)
                replacePhoto(for: newPhoto.id, with: newPhoto)
                completion(.success(nil))
            case .failure(let error):
                Log.error(error: error)
                completion(.failure(error))
            }
            self.changeLikeTask = nil
        }
        
        self.changeLikeTask = task
        task.resume()
        
    }
    
    //MARK: - Private functions
    private func appendNewPhotos(items: [PhotoResult]){
        for photoResult in items {
            let newPhoto = Photo(from: photoResult)
            photos.append(newPhoto)
        }
    }
    
    private func replacePhoto(for id: String, with photo: Photo){
        if let i = photos.firstIndex(where: {$0.id == id}) {
            self.photos[i] = photo
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
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
    func makeLikeChangeRequest(for token: String, photoId: String, isLike: Bool) -> URLRequest? {
        guard let baseURL,
              let urlComponents = URLComponents(url: makePhotoLikeURL(from: baseURL, for: photoId), resolvingAgainstBaseURL: true)
        else {
            let message = "Can not build url components"
            Log.warn(message: message)
            assertionFailure(message)
            return nil
        }
        
        guard let url = urlComponents.url else {
            let message = "Can not build url"
            Log.warn(message: message)
            assertionFailure(message)
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = isLike ? "POST" : "DELETE"
        
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
    
    private func makePhotoLikeURL(from baseURL :URL, for photoId: String) -> URL {
        if #available(iOS 16, *) {
            return baseURL
                .appending(path: "photos")
                .appending(path: photoId)
                .appending(path: "like")
        }
        else {
            return baseURL.appendingPathComponent("photos")
                .appendingPathComponent(photoId)
                .appendingPathComponent("like")
        }
    }
    
}

extension ImagesListService: ProfileCleanProtocol {
    func clean(){
        if changeLikeTask != nil {
            changeLikeTask?.cancel()
        }
        
        if loadPhotosTask != nil {
            loadPhotosTask?.cancel()
        }
        changeLikeTask = nil
        loadPhotosTask = nil
        lastLoadedPage = nil
        photos = []
    }
}
