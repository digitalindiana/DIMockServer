//
//  Coin.swift
//  DIMockServerDemo
//
//  Created by Piotr Adamczak on 08.12.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import SwiftyJSON

class Coin {
    var uid: String!
    var name: String!
    var symbol: String!
    var rank: Int!
    var priceUsd: Double!
    var priceBtc: Double!
    var lastPriceBtc: Double?
    var currency: String?
    var price: Double?

    // Mappable
    required init(JSON: JSON) {
        lastPriceBtc = priceBtc
        uid          = JSON["id"].stringValue
        name         = JSON["name"].stringValue
        symbol       = JSON["symbol"].stringValue
        rank         = JSON["rank"].intValue
        priceUsd     = JSON["price_usd"].doubleValue
        priceBtc     = JSON["price_btc"].doubleValue
    }

    func formattedPrice() -> String {
        guard let currency = currency,
              let price = price else {
                return String(format: "%.3f USD", self.priceUsd)
        }

        return String(format: "%.3f %@", price, currency)
    }

    func formattedDifference() -> String {
        guard let lastPriceBtc = lastPriceBtc else {
            return "0.000%"
        }

        if (lastPriceBtc == 0) {
            return "0.000%"
        }

        let difference = ((self.priceBtc - lastPriceBtc) / lastPriceBtc) * 100.0
        let formattedDifference = String(format: "%.3f", difference)

        var sign = ""
        if (difference > 0) {
            sign = "+"
        } else if (difference < 0) {
            sign = "-"
        }

        return "\(sign)\(formattedDifference)"
    }
}
