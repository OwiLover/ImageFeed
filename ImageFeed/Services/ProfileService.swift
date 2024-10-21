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

final class ProfileService {
    
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    private var task: URLSessionDataTask?
    
    private let urlSession = URLSession.shared
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {

        if  task != nil {
            print("New Profile task, stopping current one!")
            task?.cancel()
        }
        
        let makeCompletionOnMainThread: (Result<Profile, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        guard let request = URLRequest.makeSplashApiGetRequest(path: "/me", token: token) else {
            print(ProfileServiceErrors.urlCreationError)
            completion(.failure(ProfileServiceErrors.urlCreationError))
            return
        }
        
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
                print(ProfileServiceErrors.outsideError(error))
                makeCompletionOnMainThread(.failure(ProfileServiceErrors.outsideError(error)))
            }
            self.task = nil
        }
        self.task = sessionTask
        sessionTask.resume()
    }
    
    func resetProfile() {
        profile = nil
        if task != nil {
            task?.cancel()
            task = nil
        }
    }
}

