//
//  PhotosModel.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 01.09.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(from photoResult: PhotoResult)
    {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = Date.ISODateFormatter.date(from: photoResult.createdAt)
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.regular
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.likedByUser
    }
}

struct UrlResult: Codable {
    let full: String
    let regular: String
    let thumb: String
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width : Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlResult
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case width = "width"
        case height = "height"
        case likedByUser = "liked_by_user"
        case description = "description"
        case urls = "urls"
    }
}

struct PhotoLikeChangeResult: Codable {
    let photo: PhotoResult
}
