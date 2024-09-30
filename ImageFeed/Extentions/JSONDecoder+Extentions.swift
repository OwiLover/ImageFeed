//
//  JSONDecoder+Extentions.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/26/24.
//

import Foundation

enum JSONDecoderErrors: Error {
    case decodingError(String)
}

extension JSONDecoder {
    func decodeData<T:Decodable>(to: T.Type, from data: Data) throws -> T {
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        let data = try decoder.decode(T.self, from: data)
        return data
    }
}
