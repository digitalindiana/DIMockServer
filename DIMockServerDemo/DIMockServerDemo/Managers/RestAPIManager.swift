//
//  RestAPIManager.swift
//  DIMockServerDemo
//
//  Created by Piotr Adamczak on 08.12.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import SwiftyJSON

typealias RestResponse = (JSON?, Error?) -> Void
typealias RestCurrencyResponse = (JSON?, String, Error?) -> Void

public enum RestAPIError: Error {
    case wrongUrl
    case requestError
}

/*
 API DOCUMENTATION
 https://coinmarketcap.com/api/
*/

class RestAPIManager {
    static let shared = RestAPIManager()
    let baseURL = "https://api.coinmarketcap.com/"

    var currentCurrency = "USD";

    func fetchTopCoins(completion: @escaping RestCurrencyResponse) {
        let currency = self.currentCurrency
        makeHTTPGetRequest(path: "v1/ticker/?limit=15&convert=\(currency)", completion: { (json, error) in
            completion(json, currency, error);
        })
    }

    func makeHTTPGetRequest(path: String, completion: @escaping RestResponse) {
        let route = "\(baseURL)\(path)"
        guard let url = URL(string: route) else {
            completion(nil, RestAPIError.wrongUrl)
            return
        }

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(JSON(data), error)
        })

        task.resume()
    }
}
