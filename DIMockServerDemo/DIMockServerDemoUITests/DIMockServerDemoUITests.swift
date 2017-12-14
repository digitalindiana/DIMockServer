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
}
