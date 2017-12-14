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
}
