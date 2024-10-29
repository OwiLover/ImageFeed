//
//  ImageListViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/27/24.
//

import Foundation

protocol ImageListViewPresenterProtocol: AnyObject {
    var controller: ImageListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    
    func viewDidLoad()

    func fetchPhotosNextPage()
    
    func updateCells()
    func configureCell(for cell: ImageListCellProtocol, with indexPath: IndexPath)
    
    func didTapLike(cell: ImageListCellProtocol)
}
