//
//  Coin.swift
//  DIMockServerDemo
//
//  Created by Piotr Adamczak on 08.12.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import SwiftyJSON

struct CoinStructure {
    static let id = "id"
    static let name = "name"
    static let symbol = "symbol"
    static let rank = "rank"
    static let priceUsd = "price_usd"
    static let priceBtc = "price_btc"
    
    static func currencyKey(currency: String) -> String {
        return "price_\(currency.lowercased())"
    }
}

class Coin {
    var uid: String!
    var name: String!
    var symbol: String!
    var rank: Int!
    var priceUsd: Double!
    var priceBtc: Double!
    var lastPriceUsd: Double?
    var currency: String?
    var price: Double?

    // Mappable
    required init(JSON: JSON, currency: String = Constants.defaultCurrency) {
        self.lastPriceUsd = priceUsd
        self.uid          = JSON[CoinStructure.id].stringValue
        self.name         = JSON[CoinStructure.name].stringValue
        self.symbol       = JSON[CoinStructure.symbol].stringValue
        self.rank         = JSON[CoinStructure.rank].intValue
        self.priceUsd     = JSON[CoinStructure.priceUsd].doubleValue
        self.priceBtc     = JSON[CoinStructure.priceBtc].doubleValue

        let currencyKey   = CoinStructure.currencyKey(currency: currency)
        self.currency     = currency
        self.price        = JSON[currencyKey].doubleValue
    }

    func formattedPrice() -> String {
        guard let currency = currency,
              let price = price else {
                return String(format: "%.2f USD", self.priceUsd)
        }

        return String(format: "%.2f %@", price, currency)
    }

    func formattedDifference() -> String {
        guard let lastPriceUsd = lastPriceUsd else {
            return "0.000%"
        }

        if (lastPriceUsd == 0) {
            return "0.000%"
        }

        let difference = ((self.priceUsd - lastPriceUsd) / lastPriceUsd) * 100.0
        let formattedDifference = String(format: "%.3f", difference)

        var sign = ""
        if (difference > 0) {
            sign = "+"
        }
        
        return "\(sign)\(formattedDifference)%"
    }
}
