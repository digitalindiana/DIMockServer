//
//  MockCase.swift
//  DIMockServer
//
//  Created by Piotr Adamczak on 26.06.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import Foundation
import Swifter
import QorumLogs

public protocol MockCase {
    var request: HttpRequest? { get set }
    func urlMappings() -> URLMappings
}

public extension MockCase {
    
    public func jsonFileResponse(_ jsonFile: String, status: Int = 200) -> HttpResponse {
        let json = JSONFileLoader.loadJSON(jsonFile) as AnyObject

        return .raw(status, "OK", ["Content-Type" : "application/json"], {
            let data = try JSONSerialization.data(withJSONObject: json)
            try $0.write(data)
        })
    }
    
    public func emptyOkResponse() -> HttpResponse {
        return .ok(.json("{}" as AnyObject))
    }
    
    public func jsonStringResponse(_ string: String) -> HttpResponse {
        
        if let encodedData = string.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: encodedData, options: [.mutableContainers, .mutableLeaves])
                return .ok(.json(json as AnyObject))
                
            } catch {
                QL2("MOCK_SERVER: ERROR: Unable to parse \(string)")
                return .internalServerError
            }
            
        }
        
        return .internalServerError
    }

    public func fileResponse(filename: String, fileExtension: String) -> HttpResponse {
        guard let type = type(of: self) as? AnyClass,
            let path = Bundle(for: type).url(forResource: filename, withExtension: fileExtension),
            let fileContent = try? String(contentsOf: path.absoluteURL, encoding: .utf8) else {
                return .notFound
        }

        return .ok(.text(fileContent))
    }

}
