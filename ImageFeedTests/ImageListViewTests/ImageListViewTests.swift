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
        
        let cell = ImageListCellDummy()
        let indexPath = IndexPath(row: 0, section: 0)

//        when
        presenter.updateCells()
        presenter.configureCell(for: cell, with: indexPath)
//        then
        XCTAssertEqual(presenter.photos[safe: indexPath.row], controller.configInfo?.photo)
        XCTAssertNotNil(controller.configInfo?.date)
        XCTAssertNotEqual("", controller.configInfo?.date)
    }
    
    func testPresenterDidTapLike() {
//        given
        let imageListServiceSpy = ImageListServiceSpy(numberOfPhotos: 10)
        
        let presenter = ImageListViewPresenter(imageListService: imageListServiceSpy)
        
        let controller = ImageListViewControllerSpy()
        controller.setPresenter(presenter: presenter)
        
        let cell = ImageListCellDummy()
//        when
        presenter.updateCells()
        presenter.didTapLike(cell: cell)
//        then
        XCTAssertTrue(controller.showLoadingIndicatorDidCalled)
        XCTAssertTrue(imageListServiceSpy.changeLikeWasCalled)
    }
    
    /* 
     Не совсем понятно, как можно протестировать асинхронный результат работы ImageListService внутри функции didTapLike,
     чтобы проверить, сработала-ли функция контроллера hideLoadingIndicator и другие функции
     На ум пришло только заставить подождать пару секунд тест с помощью asyncAfter, результат приведён ниже
     */
    
    func testPresenterDidTapLikeExtended() {
//        given
        let imageListServiceSpy = ImageListServiceSpy(numberOfPhotos: 10)
                
        let presenter = ImageListViewPresenter(imageListService: imageListServiceSpy)
                
        let controller = ImageListViewControllerSpy()
        controller.setPresenter(presenter: presenter)
                
        let cell = ImageListCellSpy()
        
//        when
        presenter.updateCells()
        presenter.didTapLike(cell: cell)
        
        let timeInSeconds = 2.0
        let expectation = XCTestExpectation(description: "Waiting for something")

        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeInSeconds + 1.0)

//        then
        XCTAssertTrue(controller.showLoadingIndicatorDidCalled)
        XCTAssertTrue(controller.hideLoadingIndicatorDidCalled)
        XCTAssertTrue(controller.checkLoadingCallOrder())
        XCTAssert(cell.setLikeStatusCalled)
        XCTAssertTrue(imageListServiceSpy.changeLikeWasCalled)
    }
}
