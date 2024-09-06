//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 12.07.2024.
//

import Foundation

extension Date {
    
    static let dateFormatter = newDateFormatter()
    static let ISODateFormatter = newISODateFormatter()
    
    private static func newDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }
    
    private static func newISODateFormatter() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        return formatter
    }
    
    var dateString: String {
        return Date.dateFormatter.string(from: self)
    }
    
    var timeStampString: String {
        return Date.ISODateFormatter.string(from: self)
    }
}
