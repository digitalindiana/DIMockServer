//
//  URLMapper.swift
//  DIMockServer
//
//  Created by Piotr Adamczak on 26.06.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import Foundation
import Swifter
import QorumLogs

public typealias URLMappings = [String: RequestHandlerBlock]
public typealias RequestHandlerBlock = () throws -> HttpResponse

class URLMockMapper {

    static let semaphoreTimeout : Int = 10
    private let semaphore = DispatchSemaphore(value: semaphoreTimeout)
    
    func map(_ server: HttpServer, mock: MockCase) {

        self.addHandlersTo(server: server, mock: mock, urlMappings: mock.urlMappings())

        server.notFoundHandler = { request in
            QL3("MOCK_SERVER: Mock server warning: URL not handled path:\(request.path) params:\(request.params)")
            return .notFound
        }
    }
    
    private func handleRequest(_ mock: MockCase,
                               request: HttpRequest,
                               requestHandler: RequestHandlerBlock) -> HttpResponse {
        
        _ = semaphore.wait(timeout: .distantFuture)

        var mock = mock
        mock.request = request
        let response = try! requestHandler()
        mock.request = nil
        
        semaphore.signal()
        
        return response
    }

    private func addHandlersTo(server: HttpServer, mock: MockCase, urlMappings: URLMappings) {
        for urlMapping in urlMappings {
            server[urlMapping.key] = { request in
                self.handleRequest(mock, request: request, requestHandler: urlMapping.value)
            }
        }
    }
}
