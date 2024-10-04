//
//  URLRequest+Extentions.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/4/24.
//

import Foundation

extension URLRequest {
    static func makeSplashApiGetRequest(path: String, token: String) -> URLRequest? {
        guard let url: URL = {
            guard var urlComponents = URLComponents(string: Constants.defaultApiURLString) else {
                return nil
            }
            urlComponents.path = path
            return urlComponents.url
        }() else { return nil }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
