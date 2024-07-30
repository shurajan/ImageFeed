//
//  NetworkService.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 29.07.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkService: NetworkRouting {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
