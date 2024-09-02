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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = dateFormatter.date(from: photoResult.createdAt)
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.likedByUser
    }
}

struct UrlResult: Codable {
    let full: String
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
