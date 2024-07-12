//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 12.07.2024.
//

import Foundation

private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

extension Date {
    var dateString: String { dateFormatter.string(from: self) }
}
