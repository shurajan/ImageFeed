//
//  ImageListServiceStub.swift
//  ImageFeedTests
//
//  Created by Alexander Bralnin on 17.09.2024.
//

@testable import ImageFeed
import XCTest

enum ImageListServiceStubSetup {
    case empty
    case withPhotos(number: Int)
}

final class ImageListServiceStub: ImageListServiceProtocol {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    var photos: [Photo] = []
    
    var setup: ImageListServiceStubSetup
    
    init(setup: ImageListServiceStubSetup = .empty){
        self.setup = setup
        
        switch self.setup {
        case .empty:
            photos = []
        case .withPhotos(let number):
            funcAddPhotos(number)
        }
        
    }
    
    var fetchPhotosNextPageCalled = false
    var changeLikeIsCalled = false
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
        
        switch self.setup {
        case .empty:
            photos = []
        case .withPhotos(let number):
            funcAddPhotos(number)
            NotificationCenter.default
                .post(
                    name: ImageListService.didChangeNotification,
                    object: self)
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void?, any Error>) -> Void) {
        changeLikeIsCalled = true
        if let i = photos.firstIndex(where: {$0.id == photoId}) {
            let oldPhoto = self.photos[i]
            let newPhoto = Photo(id: oldPhoto.id,
                                 size: oldPhoto.size,
                                 createdAt: oldPhoto.createdAt,
                                 welcomeDescription: oldPhoto.welcomeDescription,
                                 thumbImageURL: oldPhoto.thumbImageURL,
                                 largeImageURL: oldPhoto.largeImageURL,
                                 isLiked: isLike)
            photos[i] = newPhoto
        }
    }
    
    private func funcAddPhotos(_ number: Int){
        let last = photos.count
        for i in 0..<number {
            let idx = last + i
            var photo = Photo(id: "ID\(idx)",
                              size: CGSize(width: 1024, height: 768),
                              createdAt: Date.ISODateFormatter.date(from: "2024-09-09T09:09:28-04:00"),
                              welcomeDescription: "welcomeDescription\(idx)",
                              thumbImageURL: "thumbImageURL\(idx)",
                              largeImageURL: "largeImageURL\(idx)",
                              isLiked: false)
            photos.append(photo)
        }
    }
    
}
