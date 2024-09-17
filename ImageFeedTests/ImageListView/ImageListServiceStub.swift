//
//  ImageListServiceStub.swift
//  ImageFeedTests
//
//  Created by Alexander Bralnin on 17.09.2024.
//

@testable import ImageFeed
import XCTest

final class ImageListServiceStub: ImageListServiceProtocol {
    
    var photos: [Photo] = []
    
    var fetchPhotosNextPageCalled = false
    var changeLikeIsCalled = false
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void?, any Error>) -> Void) {
        changeLikeIsCalled = true
    }
    
    
    
}
