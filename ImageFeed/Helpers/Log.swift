//
//  Log.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 13.08.2024.
//

import Foundation

final class Log {
    private static let shared = Log()
    
    private init(){
    }
    
    class func info(message: String,
                    filePath: String = #file,
                    line: Int = #line,
                    function: String = #function) {
        let file = getFileName(from: filePath)
        
        print ("""
               \(Date().timeStampString)\
               INFO: \(file):\(line) - \
               \(function): \(message)
               """)
    }
    
    class func error(error: Error,
                     message: String,
                     filePath: String = #file,
                     line: Int = #line,
                     function: String = #function) {
        let file = getFileName(from: filePath)
        print ("""
               \(Date().timeStampString) \
               ERROR: \(file):\(line) - \
               \(function): \(error.localizedDescription)  \(message)
               """)
    }
    
    //MARK: - Private functions
    private class func getFileName(from filePath: String) -> String {
        guard let url = URL(string: filePath) else {
            return filePath
        }
        
        return url.lastPathComponent
    }
}
