//
//  DIMockServer.swift
//  DIMockServer
//
//  Created by Piotr Adamczak on 26.06.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import Foundation
import Swifter
import QorumLogs

public class DIMockServer : NSObject {
    
    let server: HttpServer = HttpServer()
    let baseMockCaseClass: AnyClass
    let urlMockMapper = URLMockMapper()
    var port: UInt16
    
    public var mockCaseName: String {
        didSet {
            setup()
        }
    }
    
    public required init?(_ port: UInt16 = 8080,
                          mockCaseName: String? = DIMockServer.enviromentMockCaseName(),
                          baseMockCaseClass: AnyClass,
                          enableLogs: Bool = true) {
        
        guard let mockCaseName = mockCaseName else {
            QL2("MOCK_SERVER: Will not start, empty mockCaseName")
            return nil
        }
        
        self.port = port
        self.mockCaseName = mockCaseName
        self.baseMockCaseClass = baseMockCaseClass
        QorumLogs.enabled = enableLogs
    }
    
   
    public func start() {
        stop()
        if setup() == false {
            return
        }
        
        do {
            try server.start(port)
            QL2("MOCK_SERVER: Started at port: \(port)")
        }
        catch {
            QL4("MOCK_SERVER: \(error.localizedDescription)")
        }
    }
    
    public func stop() {
        server.stop()
    }
    
    private func setup() -> Bool {
        if let mockCase = MockCaseBuilder.build(mockCaseName, baseMockCaseClass: self.baseMockCaseClass) {
            urlMockMapper.map(server, mock: mockCase)
            QL2("MOCK_SERVER: Loaded mock case: \(mockCaseName)")
            return true
        }
        
        return false
    }
}

extension DIMockServer {
    static let kEnviromentUIMockCaseNameKey = "UIMockCaseName"
    
    public static func enviromentMockCaseName() -> String? {
        return ProcessInfo.processInfo.environment[kEnviromentUIMockCaseNameKey]
    }
}
