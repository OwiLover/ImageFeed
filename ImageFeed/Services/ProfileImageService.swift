//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/24/24.
//

import Foundation

enum ProfileImageErrors: Error {
    case urlCreationError
    case selfIsNilError
    case tokenIsNilError
    case noImageUrlError
    case outsideError(Error)
}

/*
 Есть ли смысл оставлять структуры в сервисах?
 С одной стороны в случае проблем с декодированием, они в одном файле и это удобно
 С другой они занимают место и при открытии файла нужно искать, где начинается класс
 */

struct UserResult: Codable {
    let profileImage: ProfileImage
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private(set) var avatarURLString: String?
    
    private var task: URLSessionDataTask?
    
    private let urlSession = URLSession.shared
    
    private let tokenStorage = OAuthTokenStorage.shared
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        if  task != nil {
            print("New ProfileImage task, stopping current one!")
            task?.cancel()
        }
        
        let makeCompletionOnMainThread: (Result<String, Error>) -> Void = { [weak self] result in
            DispatchQueue.main.async {
                completion(result)
                
                NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self?.avatarURLString as Any])
            }
        }
        
        guard let token = tokenStorage.token else {
            print(ProfileImageErrors.tokenIsNilError)
            makeCompletionOnMainThread(.failure(ProfileImageErrors.tokenIsNilError))
            return
        }
        
        guard let url: URL = {
            guard var urlComponents = URLComponents(string: Constants.defaultApiURLString) else {
                return nil
            }
            urlComponents.path = "/users/\(username)"
            return urlComponents.url
        }()
        else {
            print(ProfileImageErrors.urlCreationError)
            completion(.failure(ProfileImageErrors.urlCreationError))
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let sessionTask = urlSession.makeDecodedDataAndDataTask(with: request) { [weak self] (result: Result<UserResult, Error>) in
            
            guard let self else {
                print(ProfileImageErrors.selfIsNilError)
                makeCompletionOnMainThread(.failure(ProfileImageErrors.selfIsNilError))
                return
            }
            
            switch result {
            case .success(let result):
                guard let imageString = result.profileImage.large else {
                    print(ProfileImageErrors.noImageUrlError)
                    makeCompletionOnMainThread(.failure(ProfileImageErrors.noImageUrlError))
                    return
                }
                self.avatarURLString = imageString
                print(imageString)
                makeCompletionOnMainThread(.success(imageString))

            case .failure(let error):
                print(ProfileImageErrors.outsideError(error))
                makeCompletionOnMainThread(.failure(ProfileImageErrors.outsideError(error)))
            }
            self.task = nil
        }
        
        self.task = sessionTask
        sessionTask.resume()
    }
}
