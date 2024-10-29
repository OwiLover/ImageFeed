//
//  ImageListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/27/24.
//

import Foundation

protocol ImageListViewControllerProtocol: AnyObject {
    
    func setPresenter(presenter: ImageListViewPresenterProtocol)
    
    func updateCells(oldCount: Int, newCount: Int)
    func configCell(for cell: ImageListCellProtocol, photo: Photo, date: String)
    
    func getImageListCellIndexPath(_ cell: ImageListCellProtocol) -> IndexPath?
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showErrorAlert(message: String)
}
