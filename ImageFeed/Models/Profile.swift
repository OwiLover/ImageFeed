//
//  Profile.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/3/24.
//

import Foundation

struct Profile {
    let username: String
    private let firstName: String
    private let lastName: String?
    var name: String {
        get {
            return "\(self.firstName) \(self.lastName ?? "")"
        }
    }
    var loginName: String {
        get {
            return "@\(username)"
        }
    }
    let bio: String?
}

extension Profile {
    init(profileResult: ProfileResult) {
        self.init(username: profileResult.username, firstName: profileResult.firstName, lastName: profileResult.lastName, bio: profileResult.bio)
    }
}
