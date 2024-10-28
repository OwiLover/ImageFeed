//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/22/24.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testDemo() {
    }
    
    func testViewControllerCallsViewDidLoad() {
//            given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.webView = viewController
        
//        when
        
        _ = viewController.view
        
//        then
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
//        given
        let viewController = WebViewControllerSpy()
        
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        
        viewController.presenter = presenter
        presenter.webView = viewController
        
//        when
        presenter.viewDidLoad()
        
//        then
        XCTAssertTrue(viewController.didLoadCalled)
    }
    
    func testPresenterHiddenProgressWhenNotOne() {
//        given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
//        when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
//        then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testPresenterProgressHiddenWhenOne() {
//        given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
//        when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
//        then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperHasUrl() {
//        given
        guard let configuration = AuthConfiguration.standard else {
           XCTFail("Standart AuthConfiguration is nil!")
           return
        }
        
        let authHelper = AuthHelper(configuration: configuration)
        
//        when
        let url = authHelper.authURL()
        
        guard let urlString = url?.absoluteString else {
            XCTFail("URL String is nil!")
            return
        }
        
//        then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
//        given
        let authHelper = AuthHelper()
        let urlString = "https://unsplash.com/oauth/authorize/native"
        let testCodeValue = "test code"
        
        guard var urlComponents = URLComponents(string: urlString) else {
            XCTFail("UrlComponents is Nil!")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: testCodeValue)
        ]
        
        guard let url = urlComponents.url else {
            XCTFail("Url is Nil!")
            return
        }
        
//        when
        let code = authHelper.code(from: url)
        
//        then
        XCTAssertEqual(testCodeValue, code)
    }
}
