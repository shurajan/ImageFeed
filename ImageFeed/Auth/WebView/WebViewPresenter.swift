//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 13.09.2024.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    private var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol){
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
        
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double){
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
