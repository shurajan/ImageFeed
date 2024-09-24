//
//  ImageListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Alexander Bralnin on 17.09.2024.
//

@testable import ImageFeed
import XCTest

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    weak var view: ImageListViewControllerProtocol?
    
    var photos: [ImageFeed.Photo] = []
    
    var viewDidLoadCalled = false
    var loadPhotosNextPageNumOfCalls = 0
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func loadPhotosNextPage() {
        loadPhotosNextPageNumOfCalls += 1
    }
    
    func didTapLike(index: Int, completion: @escaping (Result<ImageFeed.Photo, any Error>) -> Void) {
    }
    
    
}
