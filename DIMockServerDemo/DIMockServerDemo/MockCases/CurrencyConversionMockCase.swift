//
//  CurrencyConversionMockCase.swift
//  DIMockServerDemo
//
//  Created by Przemysław Szurmak on 13.12.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import Foundation
import DIMockServer
import Swifter

class CurrencyConversionMockCase: DemoMockCase {
    override func ticker() throws -> HttpResponse {
        
        
        let btcPriceUsd = String(1000)
        let bitcoin: [String : Any] = [CoinStructure.id: "btc",
                       CoinStructure.name: "Bitcoin",
                       CoinStructure.symbol: "BTC",
                       CoinStructure.rank: "1",
                       CoinStructure.priceUsd: btcPriceUsd,
                       CoinStructure.priceBtc: "1.0",
                       "ticker_prices": [
                        [ "price_key": CoinStructure.currencyKey(currency: "PLN"),
                          "price_key_value": "123.0"],
                        [ "price_key": CoinStructure.currencyKey(currency: "AUD"),
                          "price_key_value": "999.99"]]
        ]
        
        let ethPriceUsd = String(10)
        let ethereum: [String : Any] = [CoinStructure.id: "ethereum",
                        CoinStructure.name: "Ethereum",
                        CoinStructure.symbol: "ETH",
                        CoinStructure.rank: "2",
                        CoinStructure.priceUsd: ethPriceUsd,
                        CoinStructure.priceBtc: "0.02126",
                        "ticker_prices": [
                            [ "price_key": CoinStructure.currencyKey(currency: "PLN"),
                              "price_key_value": "4343.0"],
                            [ "price_key": CoinStructure.currencyKey(currency: "AUD"),
                              "price_key_value": "777.0"]]
        ]
        
        let tickers = TemplateBuilder.buildTemplate(name: "Tickers", with: ["tickers":[bitcoin, ethereum]])
        return jsonStringResponse(tickers)
    }
}
