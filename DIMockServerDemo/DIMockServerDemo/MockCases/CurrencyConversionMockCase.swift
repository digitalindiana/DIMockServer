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
        let bitcoin = [CoinStructure.id: "btc",
                       CoinStructure.name: "Bitcoin",
                       CoinStructure.symbol: "BTC",
                       CoinStructure.rank: "1",
                       CoinStructure.priceUsd: btcPriceUsd,
                       CoinStructure.priceBtc: "1.0"]
        
        let ethPriceUsd = String(10)
        let ethereum = [CoinStructure.id: "ethereum",
                        CoinStructure.name: "Ethereum",
                        CoinStructure.symbol: "ETH",
                        CoinStructure.rank: "2",
                        CoinStructure.priceUsd: ethPriceUsd,
                        CoinStructure.priceBtc: "0.02126"]
        
        let tickers = TemplateBuilder.buildTemplate(name: "Tickers", with: ["tickers":[bitcoin, ethereum]])
        return jsonStringResponse(tickers)
    }
}
