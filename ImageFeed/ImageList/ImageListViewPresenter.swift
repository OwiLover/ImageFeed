//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/27/24.
//

import Foundation

class ImageListViewPresenter: ImageListViewPresenterProtocol {

    weak var controller: ImageListViewControllerProtocol?
    
    private let imageListService: ImageListServiceProtocol
    
    private(set) var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    init(imageListService: ImageListServiceProtocol = ImageListService.shared) {
        self.imageListService = imageListService
        print("ImageListViewPresenter was initialized!")
    }
    
    func viewDidLoad() {
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage()
    }
    
    func updateCells() {
        let photos = imageListService.photos
        
        let oldCount = self.photos.count
        self.photos = photos
        let newCount = self.photos.count
        controller?.updateCells(oldCount: oldCount, newCount: newCount)
    }
    
    func configureCell(for cell: ImageListCell, with indexPath: IndexPath) {
        guard let photo = photos[safe: indexPath.row], (controller != nil) else { return }
        
        var date = ""
        if let photoDate = photo.createdAt {
            date = dateFormatter.string(from: photoDate)
        }
        
        controller?.configCell(for: cell, photo: photo, date: date)
    }
    
    func didTabLike(cell: ImageListCell) {
        guard let indexPath = controller?.getImageListCellIndexPath(cell), let photo = self.getPhotoFromPhotos(index: indexPath.row) else { return }
        
        controller?.showLoadingIndicator()
        
        imageListService.changeLike(photoId: photo.id, isLiked: photo.isLiked) { [weak self]
            result in
            guard let self else { return }
            
            switch result {
            case .success(let selectedPhoto):
                
                guard let index = self.findPhotoIndexFromPhotos(photo: selectedPhoto.photo),
                      let photo = self.getPhotoFromPhotos(index: index) else { return }
                
                let isLiked = selectedPhoto.photo.likedByUser
                
                let newPhoto = Photo(photo: photo, likeStatus: isLiked)
                
                self.updatePhotoAt(index: index, newPhoto: newPhoto)
                
                print(isLiked ? "Photo was liked!" : "Photo was disliked!")
                
                cell.setLikeStatus(isLiked: isLiked)
                controller?.hideLoadingIndicator()
                
            case .failure(let error):
                print(error)
        
                controller?.hideLoadingIndicator()
                controller?.showErrorAlert(message: "Не удалось изменить лайк")
            }
        }
    }
    
    private func updatePhotoAt(index: Int, newPhoto: Photo) {
        guard photos[safe: index] != nil else { return }
        photos[index] = newPhoto
    }
    
    private func findPhotoIndexFromPhotos(photo: SelectedPhoto) -> Int? {
        return photos.firstIndex(where: {
            photoFromArray in
            photoFromArray.id == photo.id
        })
    }
    
    private func getPhotoFromPhotos(index: Int) -> Photo? {
        return photos[safe: index]
    }
}
