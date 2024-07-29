//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 29.07.2024.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject  {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
