//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/23/24.
//

import Foundation

enum ProfileServiceErrors: Error {
    case urlCreationError
    case selfIsNilError
    case outsideError(Error)
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let email: String
    let portfolioUrl: URL?
    let location: String?
    let bio: String?
}
    
struct Profile {
    let username: String
    private let firstName: String
    private let lastName: String?
    var name: String {
        get {
            return "\(self.firstName) \(self.lastName ?? "")"
        }
    }
    var loginName: String {
        get {
            return "@\(username)"
        }
    }
    let bio: String?
}

extension Profile {
    init(profileResult: ProfileResult) {
        self.init(username: profileResult.username, firstName: profileResult.firstName, lastName: profileResult.lastName, bio: profileResult.bio)
    }
}

final class ProfileService {
    
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    private var task: URLSessionDataTask?
    
    private let urlSession = URLSession.shared
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        /*
         Решил начинать новую работу без проверки на идентичность токена, поскольку есть возможность, что в профиле может что-то обновиться и рациональнее обрабатывать всегда самый новый task
         */
        if  task != nil {
            print("New Profile task, stopping current one!")
            task?.cancel()
        }
        
        let makeCompletionOnMainThread: (Result<Profile, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        guard let url: URL = {
            guard var urlComponents = URLComponents(string: Constants.defaultApiURLString) else {
                return nil
            }
            urlComponents.path = "/me"
            return urlComponents.url
        }()
        
        else {
            print(ProfileServiceErrors.urlCreationError)
            completion(.failure(ProfileServiceErrors.urlCreationError))
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let sessionTask = urlSession.makeDecodedDataAndDataTask(with: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else {
                print(ProfileServiceErrors.selfIsNilError)
                makeCompletionOnMainThread(.failure(ProfileServiceErrors.selfIsNilError))
                return
            }
            
            switch result {
            case .success(let profileResult):
                let profile = Profile(profileResult: profileResult)
                self.profile = profile
                print(profile.username)
                makeCompletionOnMainThread(.success(profile))

            case .failure(let error):
                print(error)
                makeCompletionOnMainThread(.failure(ProfileServiceErrors.outsideError(error)))
            }
            self.task = nil
        }
        self.task = sessionTask
        sessionTask.resume()
    }
}

