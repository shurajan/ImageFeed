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
    
    func testViewPresenter() {
        //given
        let imageListService = ImageListServiceStub()
        let presenter = ImageListPresenter(imageListService: imageListService)

        //when
        presenter.didTapLike(index: 0) { _ in }
        presenter.loadPhotosNextPage()
        
        //then
        XCTAssertTrue(imageListService.changeLikeIsCalled)
        XCTAssertTrue(imageListService.fetchPhotosNextPageCalled)
        
    }
    
}

