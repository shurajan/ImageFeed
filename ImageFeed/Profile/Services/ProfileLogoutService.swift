//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 03.09.2024.
//


import Foundation
import WebKit

protocol ProfileLogoutServiceProtocol{
    func logout()
}

final class ProfileLogoutService: ProfileLogoutServiceProtocol {
    static let shared = ProfileLogoutService()
    
    private let services: [ProfileCleanProtocol] = [
        ProfileImageService.shared,
        ProfileService.shared,
        OAuth2Service.shared,
        OAuth2TokenStorage.shared,
        ImagesListService.shared
    ]
    
    private init() { }
    
    func logout() {
        cleanCookies()
        Log.info(message: "Cleaned cookies")
        
        for service in services {
            service.clean()
        }
        Log.info(message: "Cleaned services")
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
