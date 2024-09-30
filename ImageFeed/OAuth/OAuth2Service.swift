//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/6/24.
//

import Foundation

enum AuthServiceError: Error {
    case equalCode
    case badTokenRequest
    case notMainThread
    case outsideError(Error)
    case urlLoadingError
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard Thread.isMainThread else {
            print(AuthServiceError.notMainThread)
            completion(.failure(AuthServiceError.notMainThread))
            return
        }
        if task != nil {
            if lastCode != code {
                print("New token, stopping current Auth task!")
                task?.cancel()
            } else {
                print(AuthServiceError.equalCode)
                completion(.failure(AuthServiceError.equalCode))
                return
            }
        } else {
            if lastCode == code {
                print(AuthServiceError.equalCode)
                completion(.failure(AuthServiceError.equalCode))
                return
            }
        }

        lastCode = code
        
        guard let tokenRequest = makeOAuthTokenRequest(code: code) else {
            print(AuthServiceError.badTokenRequest)
            completion(.failure(AuthServiceError.badTokenRequest))
            return
        }
        
        let sessionTask = URLSession.shared.makeDecodedDataAndDataTask(with: tokenRequest) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let result):
                let accessToken = result.accessToken
                print(accessToken)
                completion(.success(accessToken))
            case .failure(let error):
                print(AuthServiceError.outsideError(error))
                completion(.failure(AuthServiceError.outsideError(error)))
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
                print(AuthServiceError.urlLoadingError)
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
            print(AuthServiceError.urlLoadingError)
            return nil
        }
        
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
}
