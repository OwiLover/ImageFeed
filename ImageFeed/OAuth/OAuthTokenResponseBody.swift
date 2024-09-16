//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/11/24.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int64
}
