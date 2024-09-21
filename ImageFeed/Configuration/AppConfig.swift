//
//  AppConfig.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 21.09.2024.
//

import Foundation

struct AppConfig {
    static var maxPages: Int {
        if ProcessInfo.processInfo.arguments.contains("UITEST") {
            return 3
        } else {
            return Int.max
        }
    }
}
