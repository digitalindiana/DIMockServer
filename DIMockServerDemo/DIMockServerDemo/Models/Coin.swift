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
    required init(JSON: JSON, currency: String = Constants.defaultCurrency) {
        self.lastPriceBtc = priceBtc
        self.uid          = JSON["id"].stringValue
        self.name         = JSON["name"].stringValue
        self.symbol       = JSON["symbol"].stringValue
        self.rank         = JSON["rank"].intValue
        self.priceUsd     = JSON["price_usd"].doubleValue
        self.priceBtc     = JSON["price_btc"].doubleValue

        let currencyKey   = "price_\(currency.lowercased())"
        self.currency     = currency
        self.price        = JSON[currencyKey].doubleValue
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
