//
//  SelectedPhotoResult.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/7/24.
//

import Foundation

struct SelectedPhotoResult: Codable {
    let photo: SelectedPhoto
}

struct SelectedPhoto: Codable {
    let id: String
    let likedByUser: Bool
}
