//
//  RestAPIManager.swift
//  DIMockServerDemo
//
//  Created by Piotr Adamczak on 08.12.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import SwiftyJSON

typealias RestResponse = (JSON?, Error?) -> Void

public enum RestAPIError: Error {
    case wrongUrl
    case requestError
}

class RestAPIManager {
    static let shared = RestAPIManager()

    let baseURL = "https://api.coinmarketcap.com/"

    func fetchTopCoins(completion: @escaping RestResponse) {
        makeHTTPGetRequest(path: "v1/ticker/?limit=15", completion: completion)
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
