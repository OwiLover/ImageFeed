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
    case loadingError
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private init() {
        
    }
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let tokenRequest = try makeOAuthTokenRequest(code: code)
            
            let sessionTask = URLSession.shared.data(for: tokenRequest) { result in
                let decoder = JSONDecoder()
                switch result {
                case .success(let data):
                    do {
                        let decodedData = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                
                        let accessToken = decodedData.accessToken
                        completion(.success(accessToken))
                    } catch {
                        completion(.failure(error))
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
        guard let baseURL = URL(string: "https://unsplash.com"),
              let url = URL(
                  string: "/oauth/token"
                  + "?client_id=\(Constants.accessKey)"
                  + "&&client_secret=\(Constants.secretKey)"
                  + "&&redirect_uri=\(Constants.redirectURI)"
                  + "&&code=\(code)"
                  + "&&grant_type=authorization_code",
                  relativeTo: baseURL
              )
        else { throw NetworkError.loadingError }

         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
}

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
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}
