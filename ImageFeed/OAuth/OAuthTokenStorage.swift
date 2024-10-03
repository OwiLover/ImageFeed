//
//  OAuthTokenStorage.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/11/24.
//

import Foundation
import SwiftKeychainWrapper

final class OAuthTokenStorage {
    enum Keys: String {
        case token = "token"
    }
    
    static let shared = OAuthTokenStorage()
    
    var token: String? {
        get {
            storage.string(forKey: Keys.token.rawValue)
        }
        set(value) {
            guard let value else { return }
            storage.set(value, forKey: Keys.token.rawValue)
        }
    }

    private let storage: KeychainWrapper = .standard
    
    private init() {}
}
