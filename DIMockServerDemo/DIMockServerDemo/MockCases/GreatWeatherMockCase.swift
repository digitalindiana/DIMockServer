//
//  GreatWeatherMockCase.swift
//  DIMockServerDemo
//
//  Created by Piotr Adamczak on 17.11.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import Foundation
import DIMockServer
import Swifter

class GreatWeatherMockCase: DemoMockCase {
    
    override func cities() throws -> HttpResponse {
        return self.jsonStringResponse("{}")
    }
    
    override func weather() throws -> HttpResponse {
        return self.jsonStringResponse("{\"response\":\"GreatWeatherMockCase_\(request?.params[":city_name"] ?? "NONE")\"}")
    }
}

