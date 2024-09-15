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

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private init() {}
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let tokenRequest = try makeOAuthTokenRequest(code: code)
            
            let sessionTask = URLSession.shared.data(for: tokenRequest) { result in
                let decoder: JSONDecoder = {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return decoder
                }()
                
                switch result {
                case .success(let data):
                    do {
                        let decodedData = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                
                        let accessToken = decodedData.accessToken
                        completion(.success(accessToken))
                    } catch {
                        print(NetworkError.decodingError)
                        completion(.failure(NetworkError.decodingError))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            sessionTask.resume()
        }
        catch {
            completion(.failure(error))
        }
    }
    
    private func makeOAuthTokenRequest(code: String) throws -> URLRequest {
        guard let url: URL = try {
            guard var urlComponents = URLComponents(string: Constants.baseURLString) else {
                print(NetworkError.urlLoadingError)
                throw NetworkError.urlLoadingError
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
            throw NetworkError.urlLoadingError
        }
        
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
}

/* Возможно я не правильно понял недочёты в работе, так что напишу здесь
 Вопрос:
 Программа уже выводит логи ошибок, они уходят в .failure и поднимаются по функциям до реализации в AuthViewController.webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String)
 Протестировав смог получить все виды ошибок, однако внёс небольшие исправления и на всякий случай добавил print каждой ошибки перед передачей в .failure
 Если я что-то не правильно понял, то объясните, пожалуйста, более подробно, в каком виде от меня требуется логирование ошибок
 */

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print(NetworkError.httpStatusCode(statusCode))
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print(NetworkError.urlRequestError(error))
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print(NetworkError.urlSessionError)
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}
