//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/3/24.
//

import Foundation

enum ImageListServiceErrors: Error {
    case urlCreationError
    case selfIsNilError
    case tokenIsNilError
    case outsideError(Error)
}

class ImageListService {
    
    static let shared = ImageListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionDataTask?
    
    /*
     Несмотря на дополнительную защиту в виде отключения реакции экрана через UIBlockingProgressHUD, решил ввести дополнительный task
     */
    private var likeTask: URLSessionDataTask?
    
    private let tokenStorage = OAuthTokenStorage.shared
    
    private init() {}
    
    /*
     Возможно стоит добавить escaping функцию для вывода ошибок в ImageListViewController случае, если новая страница с картинками не загрузилась?
     */
    
    func fetchPhotosNextPage() {
        
        guard let token = tokenStorage.token else {
            print(ImageListServiceErrors.tokenIsNilError)
            return
        }
        
        if task != nil {
            print("Task is already in progress!")
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "page", value: String(nextPage)))
        
        guard let request = URLRequest.makeSplashApiGetRequest(path: "/photos", token: token, queryItems: queryItems) else {
            print(ImageListServiceErrors.urlCreationError)
            return
        }
        
        let sessionTask = URLSession.shared.makeDecodedDataAndDataTask(with: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else {
                print(ImageListServiceErrors.selfIsNilError)
                return
            }
            switch result {
            case .success(let photosList):
                print("Photos loaded!!!!")
                for photoResult in photosList {
                    let photo = Photo(photoResult: photoResult)
                    photos.append(photo)
                }
                NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: self, userInfo: ["Photos": self.photos])
            case .failure(let error):
                print(ImageListServiceErrors.outsideError(error))
            }
            self.lastLoadedPage = nextPage
            self.task = nil
        }
        
        task = sessionTask
        
        sessionTask.resume()
    }
    
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<SelectedPhotoResult, Error>) -> Void) {
        guard let token = tokenStorage.token else {
            print(ImageListServiceErrors.tokenIsNilError)
            return
        }
        
        if likeTask != nil {
            return
        }

        guard let request = URLRequest.makeSplashApiRequest(path: "/photos/\(photoId)/like", token: token, method: isLiked ? "DELETE" : "POST") else { return }
        let task = URLSession.shared.makeDecodedDataAndDataTask(with: request) { [weak self] (result: Result<SelectedPhotoResult, Error>) in
            switch result {
            case .success(let selectedPhotoResult):
                completion(.success(selectedPhotoResult))
            case .failure(let error):
                completion(.failure(ImageListServiceErrors.outsideError(error)))
            }
            self?.likeTask = nil
        }
        likeTask = task
        task.resume()
    }
    
    func resetImageList() {
        photos = []
        lastLoadedPage = nil
        if task != nil {
            task?.cancel()
            task = nil
        }
        if likeTask != nil {
            likeTask?.cancel()
            likeTask = nil
        }
    }
}

