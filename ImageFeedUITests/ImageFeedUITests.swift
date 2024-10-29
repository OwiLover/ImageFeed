//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Owi Lover on 10/28/24.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        app.launchArguments = ["testMode"]
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        
        loginTextField.tap()
        loginTextField.typeText("")
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        
        passwordTextField.tap()
        passwordTextField.tap()
        passwordTextField.typeText("")
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        print(app.debugDescription)
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        
        sleep(2)
        
        let tablesQuery = app.tables
        
        let cell = tablesQuery.cells.element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.cells.element(boundBy: 1)
        
        print(cellToLike)
        let button = cellToLike.buttons["LikeButton"]
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        
        button.tap()
        
        sleep(2)
        
        button.tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        sleep(2)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["BackButton"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 5))
        
        backButton.tap()
    }
    
    func testProfile() throws {
        
        sleep(2)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts["Ivan Light"].exists)
        XCTAssertTrue(app.staticTexts["@ivanlight"].exists)
        
        app.buttons["logoutButton"].tap()
        
        sleep(2)
        
        app.alerts["ByeBye"].scrollViews.otherElements.buttons["yes"].tap()
    }
}
