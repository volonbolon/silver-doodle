//
//  BitcoinViewController.swift
//  SwiftID
//
//  Created by Ariel Rodriguez on 03/03/2020.
//  Copyright © 2020 Ariel Rodriguez. All rights reserved.
//

import UIKit

class BitcoinViewController: UIViewController {
    @IBOutlet weak private var checkAgain: UIButton!
    @IBOutlet weak private var primary: UILabel!
    @IBOutlet weak private var partial: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        requestPrice()
    }

    private let dollarsDisplayFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.maximumFractionDigits = 0
      formatter.numberStyle = .currency
      formatter.currencySymbol = ""
      formatter.currencyGroupingSeparator = ","
      return formatter
    }()

    private let standardFormatter = NumberFormatter()

    // MARK: - Actions
    @IBAction private func checkAgainTapped(sender: UIButton) {
      requestPrice()
    }

    // MARK: - Private methods
    private func updateLabel(price: Price) {
      guard let dollars = price.components().dollars,
            let cents = price.components().cents,
            let dollarAmount = standardFormatter.number(from: dollars) else { return }

      primary.text = dollarsDisplayFormatter.string(from: dollarAmount)
      partial.text = ".\(cents)"
    }

    private func requestPrice()  {
      let bitcoin = Coinbase.bitcoin.path

      // 1. Make URL request
      guard let url = URL(string: bitcoin) else { return }
      var request = URLRequest(url: url)
      request.cachePolicy = .reloadIgnoringCacheData

      // 2. Make networking request
      let task = URLSession.shared.dataTask(with: request) { data, _, error in

        // 3. Check for errors
        if let error = error {
          print("Error received requesting Bitcoin price: \(error.localizedDescription)")
          return
        }

        // 4. Parse the returned information
        let decoder = JSONDecoder()

        guard let data = data,
              let response = try? decoder.decode(PriceResponse.self,
                                                 from: data) else { return }

        print("Price returned: \(response.data.amount)")

        // 5. Update the UI with the parsed PriceResponse
        DispatchQueue.main.async { [weak self] in
          self?.updateLabel(price: response.data)
        }
      }

      task.resume()
    }
}
