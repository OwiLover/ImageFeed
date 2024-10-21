//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/4/24.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: Date?
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
}
