//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate: NSObjectProtocol {
    func didUpdatedLastPrice(_ rate: String )
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    
    weak var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A93D30C6-F414-44B3-85B4-8F2590631DBD"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func fecthExchangeData(currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let exchange = self.parseJson(safeData) {
                        let exchangeString = String(format: "%.2f", exchange.rate)
                        self.delegate?.didUpdatedLastPrice(exchangeString)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parseJson(_ data: Data) -> CoinData? {
        let parseJson = JSONDecoder()
        do {
            let coinData = try parseJson.decode(CoinData.self, from: data)
            return coinData
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
