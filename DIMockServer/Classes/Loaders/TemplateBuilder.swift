//
//  TemplateBuilder.swift
//  DIMockServer
//
//  Created by Piotr Adamczak on 11.12.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import Foundation
import Mustache
import QorumLogs

public class TemplateBuilder {
    
    public static func buildTemplate(bundle: Bundle? = nil, name: String, with params: Any) -> String {
        
        do {
            let repo = TemplateRepository(bundle: bundle)
            repo.configuration.contentType = .text
            
            let template = try repo.template(named: name)
            template.register(StandardLibrary.each, forKey: "each")
            let result = try template.render(params)
            
            if (result == "") {
                QL2("MOCK_SERVER: [EMPTY RESULT]: \(name)")
            }
            
            return result
        }
        catch let error as MustacheError {
            
            QL4("MOCK_SERVER: [TEMPLATE ERROR]: \(error.description)")
            return ""
        }
        catch let error {
            QL4("MOCK_SERVER: \(error.localizedDescription)")
            return ""
        }
    }
}
