//
//  OAuthTokenStorageProtocol.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/26/24.
//

import Foundation

protocol OAuthTokenStorageProtocol {
    var token: String? { get set }
    func deleteToken()
}
