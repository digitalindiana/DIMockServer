//
//  MockCaseBuilder.swift
//  DIMockServer
//
//  Created by Piotr Adamczak on 29.06.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import Foundation
import QorumLogs

class MockCaseBuilder {
    
    static func build(_ mockCaseName: String, baseMockCaseClass: AnyClass) -> MockCase? {

        let motherClassInfo = ClassInfo(baseMockCaseClass)!
        let namespace = Bundle(for: baseMockCaseClass).infoDictionary!["CFBundleExecutable"] as! String
        
        guard let existingClass = NSClassFromString("\(namespace).\(mockCaseName)") as? NSObject.Type else {
            QL4("MOCK_SERVER: ERROR: Mock case not found: \(mockCaseName)")
            MockCaseBuilder.printAvailableMockCases(baseMockCaseClass)
            return nil
        }
        
        guard let mockCaseClass = existingClass as? MockCase.Type,
              let mockCase = existingClass.init() as? MockCase else {
            QL4("MOCK_SERVER: ERROR: Could not setup mock case: \(mockCaseName)")
            MockCaseBuilder.printAvailableMockCases(baseMockCaseClass)
            return nil
        }

        return mockCase
    }
    
    static func printAvailableMockCases(_ baseMockCaseClass: AnyClass) {
        
        let motherClassInfo = ClassInfo(baseMockCaseClass)!
        let availableMockCases = ClassInfo.subclassList(for: baseMockCaseClass)
        
          QL1("MOCK_SERVER: Available mock cases:")
          QL1("\(motherClassInfo.nameInNamespace ?? "" )")

        for mockCaseClassInfo in availableMockCases {
            QL1("\(mockCaseClassInfo.nameInNamespace ?? "" )")
        }
    }
}
