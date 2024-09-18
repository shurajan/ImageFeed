//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 13.08.2024.
//

import UIKit

struct AlertButton{
    let buttonText: String
    let style: UIAlertAction.Style
    let completion: ()->Void
    
    init(buttonText: String, style: UIAlertAction.Style = .default, completion: @escaping () -> Void) {
        self.buttonText = buttonText
        self.style = style
        self.completion = completion
    }
}

struct AlertModel {
    let id: String
    let title: String
    let message: String
    let buttons: [AlertButton]
}
