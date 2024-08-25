//
//  UILabel+Extensions.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 24.08.2024.
//

import UIKit

extension UILabel {
    func addCharacterSpacing(kernValue: Double = 1.0) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
