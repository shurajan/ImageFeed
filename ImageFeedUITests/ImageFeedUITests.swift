//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Alexander Bralnin on 18.09.2024.
//

import XCTest
import Foundation

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication() // переменная приложения
    private let login = ProcessInfo.processInfo.environment["LOGIN"] ?? "YOUR_LOGIN"
    private let password = ProcessInfo.processInfo.environment["PASSWORD"] ?? "YOUR_PASSWORD"
    private let fullName = ProcessInfo.processInfo.environment["FULLNAME"] ?? "YOUR_FULLNAME"
    //USERNAME MUST BE WITH SYMBOL '@'
    private let userName = ProcessInfo.processInfo.environment["USERNAME"] ?? "@YOUR_USERNAME"
    
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        let login = ProcessInfo.processInfo.environment["LOGIN"] ?? "YOUR_LOGIN"
        let password = ProcessInfo.processInfo.environment["PASSWORD"] ?? "YOUR_PASSWORD"
        
        app.buttons["authenticateButton"].tap()
        
        let webView = app.webViews["unsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(login)
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    
    func testFeed() throws {
        
        let table = app.tables["imageListTable"]
        let cell = table.children(matching: .cell).element(boundBy: 0)
        cell.buttons.element(boundBy: 0).tap()
        
        /*
        print("end")
        sleep(5)
        //XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.swipeUp()
        
        sleep(10)
        
        let cellToLike = app.tables["imageListTable"].children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 5))
        
        let likeButton = cellToLike.buttons["likeButton"]
 
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))
        likeButton.tap()
        
        sleep(3)
        likeButton.tap()
        sleep(3)
        
        cellToLike.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        
        image.pinch(withScale: 3, velocity: 1)
        sleep(1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["backButton"]
        backButton.tap()*/
        
    }
    
    func testProfile() throws {
        let profileButton = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(profileButton.waitForExistence(timeout: 5))
        profileButton.tap()
        
        XCTAssertTrue(app.staticTexts[fullName].exists)
        XCTAssertTrue(app.staticTexts[userName].exists)
        
        app.buttons["exitButton"].tap()
        
        app.alerts["exitAlert"].scrollViews.otherElements.buttons["Да"].tap()
        
        let authenticateButton = app.buttons["authenticateButton"]
        XCTAssertTrue(authenticateButton.waitForExistence(timeout: 5))
    }
}
