//
//  ImageListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Alexander Bralnin on 17.09.2024.
//

@testable import ImageFeed
import XCTest

final class ImageListViewControllerSpy: ImageListViewControllerProtocol  {
    private var presenter: ImageListPresenterProtocol?
    
    var updateTableViewAnimatedCalled = false
    
    func configure(_ presenter: ImageListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func updateTableViewAnimated(oldNumberOfRows: Int, newNumberOfRows: Int) {
        updateTableViewAnimatedCalled = true
    }
}
