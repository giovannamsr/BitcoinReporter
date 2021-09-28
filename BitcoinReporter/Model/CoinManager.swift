//
//  CoinManager.swift
//  BitcoinReporter
//
//  Created by Giovanna Rodrigues on 27/09/21.
//

import Foundation

protocol CoinManagerDelegate{
    func coinManagerDidFailWithError(error : Error)
    func didUpdateExchangeRate(_ coinManager : CoinManager, exchangeRate: String)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "07CEA6DB-47FC-403B-B4A5-83A5DF896897"
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func fetchExchangeRate(for currency : String){
        let exchangeURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        requestData(exchangeURL)
    }
    
    func requestData(_ exchangeURL : String){
        if let url = URL(string: exchangeURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.coinManagerDidFailWithError(error: error!)
                    return
                }
                if let rawData = data {
                    if let exchangeRate = parseJson(data: rawData){
                        delegate?.didUpdateExchangeRate(self, exchangeRate: exchangeRate)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(data : Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ExchangeRateData.self, from: data)
            let rateString = String(format:"%.2f",decodedData.rate)
            return rateString
        } catch {
            delegate?.coinManagerDidFailWithError(error: error)
            return nil
        }
    }
    
}
