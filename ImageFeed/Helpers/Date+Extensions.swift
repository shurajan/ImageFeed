//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 12.07.2024.
//

import Foundation

private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"
    formatter.locale = Locale(identifier: "ru_RU")
    return formatter
}()

private let timeStampFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return dateFormatter
}()

extension Date {
    var dateString: String { dateFormatter.string(from: self) }
    var timeStampString: String { timeStampFormatter.string(from: self) }
}
