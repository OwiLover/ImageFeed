//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/3/24.
//

import Foundation

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
//    let smallS3: String
}
