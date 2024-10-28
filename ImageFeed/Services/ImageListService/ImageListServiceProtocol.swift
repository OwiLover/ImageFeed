//
//  ImageListServiceProtocol.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/27/24.
//

import Foundation

protocol ImageListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<SelectedPhotoResult, Error>) -> Void)
    func resetImageList()
}
