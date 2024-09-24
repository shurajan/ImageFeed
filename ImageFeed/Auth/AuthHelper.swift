//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 13.09.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}


final class AuthHelper: AuthHelperProtocol {
    private let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if  let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == configuration.codePath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == configuration.codeItemName})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.authorizeURLString) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: configuration.codeItemName),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        
        return urlComponents.url
    }
}
