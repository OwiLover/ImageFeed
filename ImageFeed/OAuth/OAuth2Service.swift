//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/6/24.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case urlLoadingError
    case decodingError
}

enum AuthServiceError: Error {
    case invalidRequest
    case badTokenRequest
    case notMainThread
    case authServiceError(Error)
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard Thread.isMainThread else {
            completion(.failure(AuthServiceError.notMainThread))
            return
        }
        if task != nil {
            if lastCode != code {
                print("New token, stopping current task!")
                task?.cancel()
            } else {
                print("Work already in progress!")
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                print("Work already in progress!")
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }

        lastCode = code
        
        guard let tokenRequest = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let sessionTask = URLSession.shared.makeDecodedDataAndDataTask(with: tokenRequest) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let result):
                let accessToken = result.accessToken
                
                completion(.success(accessToken))
            case .failure(let error):
                print(error)
                completion(.failure(AuthServiceError.authServiceError(error)))
            }
            self.task = nil
            self.lastCode = nil
        }

        self.task = sessionTask
        sessionTask.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let url: URL = {
            guard var urlComponents = URLComponents(string: Constants.baseURLString) else {
                print(NetworkError.urlLoadingError)
                return nil
            }
                urlComponents.path = "/oauth/token"
                urlComponents.queryItems =  [
                    URLQueryItem(name: "client_id", value: Constants.accessKey),
                    URLQueryItem(name: "client_secret", value: Constants.secretKey),
                    URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                    URLQueryItem(name: "code", value: code),
                    URLQueryItem(name: "grant_type", value: "authorization_code")
                ]
            return urlComponents.url
            }()
        else {
            print(NetworkError.urlLoadingError)
            return nil
        }
        
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
}
