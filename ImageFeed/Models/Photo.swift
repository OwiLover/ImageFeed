//
//  Photos.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/3/24.
//

import Foundation

struct Photo {
    let id: String
    let width: Int
    let height: Int
    var size: CGSize {
        return CGSize(width: width, height: height)
    }
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

extension Photo {
    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.width = photoResult.width
        self.height = photoResult.height
        self.createdAt = photoResult.createdAt
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.likedByUser
    }
    
    init(photo: Photo, likeStatus: Bool) {
        self.id = photo.id
        self.width = photo.width
        self.height = photo.height
        self.createdAt = photo.createdAt
        self.welcomeDescription = photo.welcomeDescription
        self.thumbImageURL = photo.thumbImageURL
        self.largeImageURL = photo.largeImageURL
        self.isLiked = likeStatus
    }
}
