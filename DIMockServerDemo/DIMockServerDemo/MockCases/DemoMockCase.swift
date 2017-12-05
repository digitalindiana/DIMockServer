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
    func cities() throws -> HttpResponse { return HttpResponse.notFound }
    func weather() throws -> HttpResponse { return HttpResponse.notFound }
}

class DemoMockCase: NSObject, MockCase {
    var request: HttpRequest?
    
    func cities() throws -> HttpResponse {
        return .accepted
    }
    
    func weather() throws -> HttpResponse {
        return self.jsonStringResponse("{\"response\":\"DemoMockCase_\(request?.params[":city_name"] ?? "NONE")\"}")
    }
    
    func urlMappings() -> URLMappings {
        return ["/places": self.cities,
                "/weather/:city_name": self.weather]
    }
}

