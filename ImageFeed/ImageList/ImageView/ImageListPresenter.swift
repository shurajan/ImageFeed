//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 17.09.2024.
//

import Foundation

public protocol ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    
    func viewDidLoad()
    func loadPhotosNextPage()
    func didTapLike(index: Int, completion: @escaping (Result<Photo, Error>) -> Void)
}

final class ImageListPresenter: ImageListPresenterProtocol {
    weak var view: ImageListViewControllerProtocol?
    
    private(set) var photos = [Photo]()
    private let imagesListService: ImageListServiceProtocol
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(imageListService: ImageListServiceProtocol = ImageListService.shared){
        self.imagesListService = imageListService
        self.photos = self.imagesListService.photos
    }
    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImageListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self,
                      let view = self.view else { return }
                
                let newNumberOfRows = self.imagesListService.photos.count
                let oldNumberOfRows = self.photos.count
                
                self.photos = self.imagesListService.photos
                view.updateTableViewAnimated(oldNumberOfRows: oldNumberOfRows, newNumberOfRows: newNumberOfRows)
            }
    }
    
    func loadPhotosNextPage(){
        imagesListService.fetchPhotosNextPage()
    }
    
    func didTapLike(index: Int, completion: @escaping (Result<Photo, Error>) -> Void) {
        guard let photo = photos[safe: index] else {
            Log.warn(message: "Tried to change like on image that is out of index")
            return
        }
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(_):
                self.photos = self.imagesListService.photos
                completion(.success(photos[index]))
            case .failure(let error):
                Log.error(error: error)
                completion(.failure(error))
            }
        }
    }
}
