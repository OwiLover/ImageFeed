//
//  URLRequest+Extentions.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/4/24.
//

import Foundation

extension URLRequest {
    static func makeSplashApiGetRequest(path: String, token: String, queryItems: [URLQueryItem] = [URLQueryItem]()) -> URLRequest? {
        guard let url: URL = {
            guard var urlComponents = URLComponents(string: Constants.defaultApiURLString) else {
                return nil
            }
            urlComponents.path = path
            urlComponents.queryItems = queryItems
            return urlComponents.url
        }() else { return nil }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func makeSplashApiRequest(path: String, token: String, method: String = "GET", queryItems: [URLQueryItem] = [URLQueryItem](), body: [String:Any]? = nil) -> URLRequest? {
        guard var request = makeSplashApiGetRequest(path: path, token: token, queryItems: queryItems) else { return nil }
        request.httpMethod = method
        if let body {
            do {
                let jsonBody = try JSONSerialization.data(withJSONObject: body)
                request.httpBody = jsonBody
            }
            catch {
                return nil
            }
        }
        return request
    }
}
