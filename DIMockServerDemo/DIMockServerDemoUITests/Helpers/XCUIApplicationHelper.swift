//
//  XCUIApplicationHelper.swift
//  DIMockServer
//
//  Created by Piotr Adamczak on 14.12.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.


import XCTest
import Foundation

extension XCUIApplication {

    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    
    static let settings = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
    
    static func launch(with mockCase: String?, parameters:[String]? = nil) -> XCUIApplication {
        let app = XCUIApplication()

        if let mockCase = mockCase {
            app.launchEnvironment["UIMockCaseName"] = mockCase
        }

        guard let parameters = parameters else {
            app.launch()
            return app
        }

        app.launchArguments.append(contentsOf: parameters)
        app.launch()

        return app
    }

    func goToBackground() {
        XCUIDevice().press(XCUIDeviceButton.home)
    }
    
    func goToForeground() {        
        self.activate()
    }

    func swipeUpAndTap(element: XCUIElement, forceSwipe: Bool = false) {
        if (element.exists == false || forceSwipe) {
            self.tables.cells.firstMatch.swipeUp()
        }

        if element.waitForExistence(timeout: 5.0) {
            element.tap()
        }
    }
    
    func isBackgrounded() -> Bool {
        return self.wait(for: .runningBackground, timeout: 10.0)
    }
    
    func labelContaining(_ string: String) -> XCUIElement {
        let predicate = NSPredicate(format: "label CONTAINS '\(string)'")
        return self.staticTexts.element(matching: predicate)
    }

    func pullToRefresh() {
        let mainWindow = self.windows.element(boundBy: 0)
        let heightFactor = mainWindow.frame.height / 5
        let normalized = mainWindow.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let start = normalized.withOffset(CGVector(dx: (mainWindow.frame.width / 2), dy: heightFactor))
        let finish = start.withOffset(CGVector(dx: 0, dy: (heightFactor * 2)))
        start.press(forDuration: 0, thenDragTo: finish)
    }

    func launchSettingsOnFistPage(settings: XCUIApplication) {
        settings.launch()
        settings.terminate()
        settings.launch()
    }

    func resetLocationPrivacySettings() {
        launchSettingsOnFistPage(settings: XCUIApplication.settings)
        XCUIApplication.settings.tables.staticTexts["General"].tap()
        XCUIApplication.settings.tables.staticTexts["Reset"].tap()
        XCUIApplication.settings.tables.staticTexts["Reset Location & Privacy"].tap()
        XCUIApplication.settings.buttons["Reset Warnings"].tap()
        XCUIApplication.settings.terminate()
    }
}
