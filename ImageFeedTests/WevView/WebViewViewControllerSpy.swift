//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Alexander Bralnin on 13.09.2024.
//

import Foundation
import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol{
    var presenter: (any ImageFeed.WebViewPresenterProtocol)?
    var isLoadCalled = false
    
    func load(request: URLRequest) {
        isLoadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
