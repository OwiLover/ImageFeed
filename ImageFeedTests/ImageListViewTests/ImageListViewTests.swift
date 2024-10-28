//
//  ImageListViewTests.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/28/24.
//

@testable import ImageFeed
import XCTest

final class ImageListViewTests: XCTestCase {
    func testDemo() { 
        //        given
                
        //        when
                
        //        then
        
    }
    
    func testControllerViewDidLoadCalled() {
//        given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
        guard let controller = storyboard.instantiateViewController(
            withIdentifier: "ImageListViewController"
        ) as? ImageListViewController else { return }
        
        let presenter = ImageListViewPresenterSpy()
        controller.setPresenter(presenter: presenter)
        
//        when
        _ = controller.view
        
//        then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterFetchPhotosNextPageCalled() {
//        given
        let imageListServiceSpy = ImageListServiceSpy()
        let presenter = ImageListViewPresenter(imageListService: imageListServiceSpy)
        
//        when
        presenter.fetchPhotosNextPage()
        
//        then
        XCTAssertTrue(imageListServiceSpy.fetchPhotoNextPageWasCalled)
    }
    
    func testPresenterUpdateCellsCalled() {
//        given
        let imageListServiceSpy = ImageListServiceSpy(numberOfPhotos: 10)
        
        let presenter = ImageListViewPresenter(imageListService: imageListServiceSpy)
        
        let controller = ImageListViewControllerSpy()
        controller.setPresenter(presenter: presenter)
        
//        when
        presenter.updateCells()
        
//        then
        XCTAssertTrue(controller.updateCellDidCalled)
        XCTAssertEqual(0, controller.counts?.OldCount)
        XCTAssertEqual(10, controller.counts?.NewCount)
    }
    
    func testPresenterConfigureCellCalled() {
//        given
        
        let imageListServiceSpy = ImageListServiceSpy(numberOfPhotos: 10)
        
        let presenter = ImageListViewPresenter(imageListService: imageListServiceSpy)
        
        let controller = ImageListViewControllerSpy()
        controller.setPresenter(presenter: presenter)
        
        let cell = ImageListCell()
        let indexPath = IndexPath(row: 0, section: 0)

//        when
        presenter.updateCells()
        presenter.configureCell(for: cell, with: indexPath)
//        then
        XCTAssertEqual(presenter.photos[safe: indexPath.row], controller.configInfo?.photo)
        XCTAssertNotNil(controller.configInfo?.date)
        XCTAssertNotEqual("", controller.configInfo?.date)
    }
    
    func testPresenterDidTabLike() {
//        given
        let imageListServiceSpy = ImageListServiceSpy(numberOfPhotos: 10)
        
        let presenter = ImageListViewPresenter(imageListService: imageListServiceSpy)
        
        let controller = ImageListViewControllerSpy()
        controller.setPresenter(presenter: presenter)
        
        let cell = ImageListCell()
//        when
        presenter.updateCells()
        presenter.didTabLike(cell: cell)
//        then
        XCTAssertTrue(controller.showLoadingIndicatorDidCalled)
        XCTAssertTrue(imageListServiceSpy.changeLikeWasCalled)
    }

/* не совсем понятно, как можно протестировать асинхронный результат работы ImageListService внутри функции didTabLike, чтобы проверить, сработала-ли функция контроллера hideLoadingIndicator
   на ум приходит сделать Spy презентера с семафором, однако смысл в тестировании мока не совсем понятно
 */

}
