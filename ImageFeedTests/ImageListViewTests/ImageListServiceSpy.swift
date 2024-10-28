//
//  ImageListService.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/28/24.
//
@testable import ImageFeed
import Foundation

class ImageListServiceSpy: ImageListServiceProtocol {
    var photos: [ImageFeed.Photo]
    
    var fetchPhotoNextPageWasCalled: Bool = false
    var changeLikeWasCalled: Bool = false
    
    init(photos: [ImageFeed.Photo] = []) {
        self.photos = photos
    }
    
    init(numberOfPhotos: Int) {
        self.photos = []
        
        let photo = Photo(id: "1", width: 100, height: 100, createdAt: Date(), welcomeDescription: nil, thumbImageURL: "someThumbUrl", largeImageURL: "someLargeUrl", isLiked: false)
        
        for _ in (0..<numberOfPhotos) {
            self.photos.append(photo)
        }
    }
    
    func fetchPhotosNextPage() {
        fetchPhotoNextPageWasCalled = true
        
    }
    
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<ImageFeed.SelectedPhotoResult, any Error>) -> Void) {
        changeLikeWasCalled = true
    
        let selectedPhoto = SelectedPhoto(id: "123", likedByUser: true)
        let selectedPhotoResult = SelectedPhotoResult(photo: selectedPhoto)
        completion(Result.success(selectedPhotoResult))
    }
    
    func resetImageList() {
        
    }
    
    
}
