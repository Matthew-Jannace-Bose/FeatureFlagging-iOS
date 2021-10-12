//
//  FeatureFlaggingUITests.swift
//  FeatureFlaggingUITests
//
//  Created by Matthew Jannace on 1/5/21.
//

import XCTest

class FeatureFlaggingUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSplit() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let maxCount = 5000
        
        for counter in 1...maxCount {
            print("Running Test: \(counter) of \(maxCount)")
            
            app.buttons["initializer"].tap()
            
            XCTAssert(app.staticTexts["sdkReady"].waitForExistence(timeout: 10), "SKD Not Ready")

            app.buttons["sendEvent"].tap()
            
            app.buttons["deInitialize"].tap()
            
            XCTAssert(app.staticTexts["sdkNotReady"].waitForExistence(timeout: 10), "SKD Still Ready")

            app.buttons["increment"].tap()

        }
    }
    
}
