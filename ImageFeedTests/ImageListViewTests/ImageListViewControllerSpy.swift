//
//  ImageListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/28/24.
//
@testable import ImageFeed
import Foundation
import XCTest

class ImageListViewControllerSpy: ImageListViewControllerProtocol {

    var presenter: ImageListViewPresenterProtocol?
    
    var updateCellDidCalled = false
    
    var configCellDidCalled = false
    
    var showLoadingIndicatorDidCalled = false
    var hideLoadingIndicatorDidCalled = false
    
    var showErrorAlertDidCalled = false
    
    enum calledLoadingOrder {
        case showLoadingCalled
        case hideLoadingCalled
    }
    
    var calledLoadingOrderArray: [calledLoadingOrder] = []
    
    var counts: (OldCount: Int, NewCount: Int)?
    
    var configInfo: (photo: Photo, date: String)?
    
    func setPresenter(presenter: any ImageFeed.ImageListViewPresenterProtocol) {
        self.presenter = presenter
        presenter.controller = self
    }
    
    func updateCells(oldCount: Int, newCount: Int) {
        updateCellDidCalled = true
        counts = (oldCount, newCount)
    }
    
    func configCell(for cell: ImageFeed.ImageListCellProtocol, photo: ImageFeed.Photo, date: String) {
        configCellDidCalled = true
        
        configInfo = (photo, date)
    }
    
    func getImageListCellIndexPath(_ cell: ImageFeed.ImageListCellProtocol) -> IndexPath? {
        return IndexPath(row: 1, section: 1)
    }
    
    func showLoadingIndicator() {
        showLoadingIndicatorDidCalled = true
        calledLoadingOrderArray.append(.showLoadingCalled)
    }
    
    func hideLoadingIndicator() {
        hideLoadingIndicatorDidCalled = true
        calledLoadingOrderArray.append(.hideLoadingCalled)
    }
    
    func showErrorAlert(message: String) {
        showErrorAlertDidCalled = true
    }
    
    func checkLoadingCallOrder() -> Bool {
        if (calledLoadingOrderArray.first == calledLoadingOrder.showLoadingCalled) &&
            (calledLoadingOrderArray.last == calledLoadingOrder.hideLoadingCalled) {
            return true
        }
        else {
            return false
        }
    }
}
