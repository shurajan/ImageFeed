//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 30.07.2024.
//

import Foundation
import SwiftKeychainWrapper

//MARK: - AuthService Error
enum TokenStorageError: Error {
    case setError, getError
    
    var description: String? {
        switch self {
        case .setError:
            return "Can not store token"
        case .getError:
            return "Can not get token"
        }
    }
}

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
            
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: "AuthToken")
            return token
        }
        set {
            guard let newToken = newValue else {
                Log.error(error: TokenStorageError.setError, message: "New token is empty")
                return
            }
            
            let isSuccess = KeychainWrapper.standard.set(newToken, forKey: "AuthToken")
            guard isSuccess else {
                Log.error(error: TokenStorageError.setError)
                return
            }
        }
    }
    
}
