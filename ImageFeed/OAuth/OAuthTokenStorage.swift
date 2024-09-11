//
//  OAuthTokenStorage.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/11/24.
//

import Foundation

class OAuthTokenStorage {
    
    static let shared = OAuthTokenStorage()
    
    enum Keys: String {
        case token = "token"
    }
    
    private let storage: UserDefaults = .standard
    
    var token: String? {
        get {
            storage.string(forKey: Keys.token.rawValue)
        }
        set(value) {
            storage.set(value, forKey: Keys.token.rawValue)
        }
    }
}
