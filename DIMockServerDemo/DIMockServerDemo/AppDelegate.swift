//
//  AppDelegate.swift
//  DIMockServerDemo
//
//  Created by Piotr Adamczak on 16.11.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import UIKit
import DIMockServer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    #if DEBUG
    var mockServer: DIMockServer?
    #endif
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        #if DEBUG
        self.initalizeMockServer()
        #endif
        
        return true
    }

    func initalizeMockServer() {
        UIApplication.shared.windows.first?.layer.speed = 5.0

        self.mockServer = DIMockServer(baseMockCaseClass: DemoMockCase.self)
        self.mockServer?.start()
    }
}

