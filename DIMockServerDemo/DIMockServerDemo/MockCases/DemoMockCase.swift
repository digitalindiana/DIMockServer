//
//  DemoMockCase.swift
//  DIMockServerDemo
//
//  Created by Piotr Adamczak on 17.11.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import Foundation
import DIMockServer
import Swifter

extension MockCase {
    func ticker() throws -> HttpResponse { return HttpResponse.notFound }
    func global() throws -> HttpResponse { return HttpResponse.notFound }
    func debug() throws -> HttpResponse { return HttpResponse.notFound }
}

class DemoMockCase: NSObject, MockCase {
    var request: HttpRequest?
    
    func ticker() throws -> HttpResponse {
        return self.jsonFileResponse("DefaultTickerResponse")
    }

    func global() throws -> HttpResponse {
        return self.jsonFileResponse("DefaultGlobalResponse")
    }

    func debug() throws -> HttpResponse {
        return self.jsonStringResponse("{\"request_data\":\"\(request?.params[":data"] ?? "NONE")\"}")
    }
    
    func urlMappings() -> URLMappings {
        return ["v1/ticker/?limit=:limit&convert:currency": self.ticker,
                "v1/global": self.global,
                "debug/:data": self.debug]
    }
}

