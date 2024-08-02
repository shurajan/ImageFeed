//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 30.07.2024.
//

import Foundation

//MARK: - Network Error
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    
    var description: String? {
        switch self {
        case .httpStatusCode(let code):
            return "HTTP status error: \(code)"
        case .urlRequestError(let error):
            return "Request error: \(error.localizedDescription)"
        case .urlSessionError:
            return "URL Session Error"
        }
    }
}


//MARK: - URLSession extension to load data in main thread
extension URLSession {
    func data(for request: URLRequest,
              handler: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                handler(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    let httpStatusError = NetworkError.httpStatusCode(statusCode)
                    print(httpStatusError.localizedDescription)
                    fulfillCompletionOnTheMainThread(.failure(httpStatusError))
                }
            } else if let error {
                let urlRequestError = NetworkError.urlRequestError(error)
                print(urlRequestError)
                fulfillCompletionOnTheMainThread(.failure(urlRequestError))
            } else {
                let urlSessionError = NetworkError.urlSessionError
                print(urlSessionError)
                fulfillCompletionOnTheMainThread(.failure(urlSessionError))
            }
        })
        
        return task
    }
}
