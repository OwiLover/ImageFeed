//
//  ProfileImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/26/24.
//

import Foundation

protocol ProfileImageServiceProtocol {
    var avatarURLString: String? { get }
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
    func resetProfileImage()
}
