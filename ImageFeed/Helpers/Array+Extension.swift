//
//  Array+Extension.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 18.09.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
