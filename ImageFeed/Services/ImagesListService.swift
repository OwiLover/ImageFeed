//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/3/24.
//

import Foundation

enum ImagesListServiceErrors: Error {
    case urlCreationError
    case selfIsNilError
    case tokenIsNilError
    case outsideError(Error)
}

class ImagesListService {
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionDataTask?
    
    private let tokenStorage = OAuthTokenStorage.shared
    
    private init() {}
    
    func fetchPhotosNextPage() {
        
        guard let token = tokenStorage.token else {
            print(ImagesListServiceErrors.tokenIsNilError)
            return
        }
        
        if task != nil {
            print("Task is already in progress!")
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = URLRequest.makeSplashApiGetRequest(path: "/photos", token: token) else {
            print(ImagesListServiceErrors.urlCreationError)
            return
        }
        
        let sessionTask = URLSession.shared.makeDecodedDataAndDataTask(with: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { 
                print(ImagesListServiceErrors.selfIsNilError)
                return
            }
            switch result {
            case .success(let photosList):
                for photoResult in photosList {
                    let photo = Photo(photoResult: photoResult)
                    photos.append(photo)
                }
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: ["Photos": self.photos])
            case .failure(let error):
                print(ImagesListServiceErrors.outsideError(error))
            }
            self.lastLoadedPage = nextPage
            self.task = nil
        }
        
        task = sessionTask
        
        sessionTask.resume()
    }
}
