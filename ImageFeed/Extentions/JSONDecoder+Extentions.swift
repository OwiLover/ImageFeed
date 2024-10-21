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
        self.keyDecodingStrategy = .convertFromSnakeCase
        self.dateDecodingStrategy = .iso8601
        
        do {
            let data = try self.decode(T.self, from: data)
            return data
        }
        catch {
            throw JSONDecoderErrors.decodingError("Data: \(String(data: data, encoding: .utf8) ?? "")")
        }
    }
}
