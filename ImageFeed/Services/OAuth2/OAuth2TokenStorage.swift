//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 30.07.2024.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    //MARK: - Init
    private init(){
    }
    
    //TODO: - replace with secure storage
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            storage.string(forKey: Keys.token.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
}
