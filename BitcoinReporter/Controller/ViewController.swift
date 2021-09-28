//
//  ViewController.swift
//  BitcoinReporter
//
//  Created by Giovanna Rodrigues on 24/09/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    var currentCurrency = "USD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCurrency = coinManager.currencyArray[row]
        coinManager.fetchExchangeRate(for: currentCurrency)
    }
    
}

extension ViewController : CoinManagerDelegate{
    
    func didUpdateExchangeRate(_ coinManager: CoinManager, exchangeRate: String) {
        DispatchQueue.main.async {
            self.valueLabel.text = exchangeRate
            self.currencyLabel.text = self.currentCurrency
        }
    }
    
    func coinManagerDidFailWithError(error: Error) {
        print(error)
    }
}
