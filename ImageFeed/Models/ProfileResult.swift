//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/3/24.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let email: String
    let portfolioUrl: URL?
    let location: String?
    let bio: String?
}
