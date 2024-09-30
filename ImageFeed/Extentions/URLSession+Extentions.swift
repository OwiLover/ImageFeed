//
//  URLSession+Extentions.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/26/24.
//

import Foundation

enum URLSessionErrors: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func makeDataTask(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        let sessionTask = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    print("DataTask success!")
                    completion(.success(data))
                } else {
                    print(URLSessionErrors.httpStatusCode(statusCode))
                    completion(.failure(URLSessionErrors.httpStatusCode(statusCode)))
                }
            }
            else if let error = error {
                print(URLSessionErrors.urlRequestError(error))
                completion(.failure(URLSessionErrors.urlRequestError(error)))
            }
            else {
                print(URLSessionErrors.urlSessionError)
                completion(.failure(URLSessionErrors.urlSessionError))
            }
        })
        return sessionTask
    }
    
    func makeDecodedDataAndDataTask<T:Decodable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        
        let fulfillCompletionOnTheMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = makeDataTask(with: request) { result in
    
            switch result {
            case .success(let data):
                do {
                    let newData = try JSONDecoder().decodeData(to: T.self, from: data)
                    fulfillCompletionOnTheMainThread(.success(newData))
                } catch {
                    print(JSONDecoderErrors.decodingError("Data: \(String(data: data, encoding: .utf8) ?? "")"))
                    fulfillCompletionOnTheMainThread(.failure(JSONDecoderErrors.decodingError("Data: \(String(data: data, encoding: .utf8) ?? "")")))
                }
            case .failure(let error):
                print(error)
                fulfillCompletionOnTheMainThread(.failure(error))
            }
        }
        return task
    }
}
