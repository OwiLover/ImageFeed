//
//  ImageListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/28/24.
//
@testable import ImageFeed
import Foundation

class ImageListViewPresenterSpy: ImageListViewPresenterProtocol {
    
    weak var controller: ImageListViewControllerProtocol?
    
    private(set) var photos: [Photo] = []
    
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func findPhotoIndexFromPhotos(photo: SelectedPhoto) -> Int? {
        return nil
    }
    
    func getPhotoFromPhotos(index: Int) -> Photo? {
        return nil
    }
    
    func fetchPhotosNextPage() { }
    
    func updatePhotoAt(index: Int, newPhoto: ImageFeed.Photo) { }

    func updateCells() { }
    
    func configureCell(for cell: ImageFeed.ImageListCellProtocol, with indexPath: IndexPath) { }
    
    func didTapLike(cell: ImageFeed.ImageListCellProtocol) { }
}
