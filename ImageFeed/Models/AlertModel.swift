//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 13.08.2024.
//

import Foundation

import Foundation

struct AlertModel {
    let id: String
    let title: String
    let message: String
    let buttonText: String
    let completion: ()->Void
}
