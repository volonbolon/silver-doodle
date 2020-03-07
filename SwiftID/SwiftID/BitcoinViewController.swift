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

    var fetcher: PriceFetcher?

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

    private func requestPrice() {
        guard let fetcher = self.fetcher else {
            fatalError("Missing dependencies")
        }
        fetcher.fetch { (priceResponse) in
            guard let response = priceResponse else {
                return
            }
            DispatchQueue.main.async {
                self.updateLabel(price: response.data)
            }
        }
    }
}
