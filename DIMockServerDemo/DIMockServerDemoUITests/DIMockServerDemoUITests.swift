//
//  DIMockServerDemoUITests.swift
//  DIMockServerDemoUITests
//
//  Created by Piotr Adamczak on 16.11.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import XCTest

class DIMockServerDemoUITests: XCTestCase {

    func testAppRunningFromDemoMockCaseWithHelper() {
        let app = XCUIApplication.launch(with: "DemoMockCase")

        let bitcoinCell = app.cells.staticTexts["Bitcoin"]
        XCTAssertTrue(bitcoinCell.waitForExistence(timeout: 10))
    }

    func testAppRunningFromDemoMockCaseWithoutHelper() {
        let app = XCUIApplication()
        app.launchEnvironment["UIMockCaseName"] = "DemoMockCase"
        app.launch()

        let bitcoinCell = app.cells.staticTexts["Bitcoin"]
        XCTAssertTrue(bitcoinCell.waitForExistence(timeout: 10))
    }

    func testAppRunningFromDemoMockCaseFailedScenario() {
        let app = XCUIApplication.launch(with: "DemoMockCase")

        let bitcoinCell = app.cells.staticTexts["ShitCoin"]
        XCTAssertFalse(bitcoinCell.waitForExistence(timeout: 10))
    }

    func testPriceDifferenceAfterPullRefresh() {
        let app = XCUIApplication.launch(with: "DynamicPriceDifferenceMockCase")

        let zeroPrecentDifference = app.cells.staticTexts["0.000%"]
        XCTAssertTrue(zeroPrecentDifference.waitForExistence(timeout: 10))

        app.pullToRefresh()

        let oneHundredPrecentDifference = app.cells.staticTexts["+100.000%"]
        XCTAssertTrue(oneHundredPrecentDifference.waitForExistence(timeout: 10))

        app.pullToRefresh()

        let fiftyPrecentDifference = app.labelContaining("50.000%")
        XCTAssertTrue(fiftyPrecentDifference.waitForExistence(timeout: 10))

        app.pullToRefresh()

        let oneThirdPrecentDifference = app.cells.staticTexts["+33.333%"]
        XCTAssertTrue(oneThirdPrecentDifference.waitForExistence(timeout: 10))
    }
    
    func testCurrencyConversion() -> Void {
        let app = XCUIApplication.launch(with: "CurrencyConversionMockCase")
        
        
        let tablesQuery = app.tables
        let bitcoinUSDPrice = tablesQuery.staticTexts["1000.00 USD"]
        XCTAssertTrue(bitcoinUSDPrice.waitForExistence(timeout: 10))
        
        let etherumUSDPrice = tablesQuery.staticTexts["10.00 USD"]
        XCTAssertTrue(etherumUSDPrice.waitForExistence(timeout: 10))
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Settings"].tap()
        
        app.tables.staticTexts["Selected currency"].tap()
        
        
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "PLN")
        
        app.toolbars.buttons["Done"].tap()
        tabBarsQuery.buttons["Coins"].tap()
        
        let bitcoinPLNPrice = tablesQuery.staticTexts["123.00 PLN"]
        XCTAssertTrue(bitcoinPLNPrice.waitForExistence(timeout: 10))
        
        let etherumPLNPrice = tablesQuery.staticTexts["4343.00 PLN"]
        XCTAssertTrue(etherumPLNPrice.waitForExistence(timeout: 10))
    }
}
