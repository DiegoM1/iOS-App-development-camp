//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController {
    
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currentlyLabel: UILabel!
    @IBOutlet weak var currentlyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currentlyPicker.dataSource = self
        currentlyPicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
}

extension CoinViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currently = coinManager.currencyArray[row]
        currentlyLabel.text = currently
        coinManager.fecthExchangeData(currency: currently)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
}

extension CoinViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

extension CoinViewController: CoinManagerDelegate {
    func didUpdatedLastPrice(_ rate: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = rate
        }
    }
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
