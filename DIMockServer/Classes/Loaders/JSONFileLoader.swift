//
//  JSONFileLoader.swift
//  DIMockServer
//
//  Created by Piotr Adamczak on 26.06.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import Foundation
import QorumLogs

class JSONFileLoader {
    
    static func loadJSON(_ fileName: String, bundle: Bundle) -> Any? {
        
        guard let url  = bundle.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            QL4("MOCK_SERVER: ERROR: Unable to load \(fileName).json")
            return nil
        }
    
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch let error {
            QL4("MOCK_SERVER: ERROR: \(error)\nUnable to parse \(fileName).json")
        }
    
        return nil
    }
    
}
