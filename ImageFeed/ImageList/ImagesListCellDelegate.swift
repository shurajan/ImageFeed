//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 03.09.2024.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
} 
