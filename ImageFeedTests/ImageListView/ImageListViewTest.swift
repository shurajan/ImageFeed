//
//  ImageListViewTest.swift
//  ImageFeedTests
//
//  Created by Alexander Bralnin on 17.09.2024.
//

@testable import ImageFeed
import XCTest

final class ImageListViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imageListViewPresenter = ImageListPresenter()
        let viewController: ImageListViewController? = storyboard.instantiateViewController(
            withIdentifier: "ImageListViewController"
        ) as? ImageListViewController
        
        guard let view = viewController else {
            XCTFail("Failed to load view")
            return
        }
        
        let presenter = ImageListPresenterSpy()
        viewController?.configure(presenter)
        
        //when
        _ = view.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
        XCTAssertEqual(presenter.loadPhotosNextPageNumOfCalls, 1)
        
    }
    
    func testViewPresenterTapLikeWithEmptyPhotos() {
        //given
        let imageListService = ImageListServiceStub(setup: .empty)
        let presenter = ImageListPresenter(imageListService: imageListService)
        
        //when
        presenter.didTapLike(index: 0) { _ in }
        
        //then
        XCTAssertFalse(imageListService.changeLikeIsCalled)
    }
    
    func testViewPresenterTapLikeSuccess() {
        //given
        let imageListService = ImageListServiceStub(setup: .withPhotos(number: 10))
        let presenter = ImageListPresenter(imageListService: imageListService)
        
        //when
        presenter.didTapLike(index: 3) { _ in }
        
        //then
        XCTAssertTrue(imageListService.photos[3].isLiked)
        XCTAssertFalse(imageListService.photos[2].isLiked)
    }
    
    func testViewPresenterTapLikeOutOfIndex() {
        //given
        let imageListService = ImageListServiceStub(setup: .withPhotos(number: 10))
        let presenter = ImageListPresenter(imageListService: imageListService)
        
        //when
        presenter.didTapLike(index: 11) { _ in }
        
        //then
        XCTAssertFalse(imageListService.changeLikeIsCalled)
    }

    func testViewPresenterRequestNextPage() {
        //given
        let imageListService = ImageListServiceStub(setup: .withPhotos(number: 10))
        let presenter = ImageListPresenter(imageListService: imageListService)
        let view = ImageListViewControllerSpy()
        view.configure(presenter)
        
        //when
        presenter.viewDidLoad()
        view.requestNextPage()
        
        //then
        XCTAssertEqual(presenter.photos.count, 20)
        XCTAssertEqual(presenter.photos[19].id, "ID19")
    }
    
}

