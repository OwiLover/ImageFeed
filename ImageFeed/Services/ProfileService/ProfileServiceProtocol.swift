//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/26/24.
//

import Foundation

protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
    func resetProfile()
}
