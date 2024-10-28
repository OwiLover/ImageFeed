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
    
    func fetchPhotosNextPage() {
        
    }
    
    func findPhotoIndexFromPhotos(photo: SelectedPhoto) -> Int? {
        return nil
    }
    
    func getPhotoFromPhotos(index: Int) -> Photo? {
        return nil
    }
    
    func updatePhotoAt(index: Int, newPhoto: ImageFeed.Photo) {
        
    }
    
    func updateCells() {
        
    }
    
    func configureCell(for cell: ImageFeed.ImageListCell, with indexPath: IndexPath) {
        
    }
    
    func didTabLike(cell: ImageFeed.ImageListCell) {
        
    }
    
    
}
