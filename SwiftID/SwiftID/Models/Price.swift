//
//  Price.swift
//  SwiftID
//
//  Created by Ariel Rodriguez on 03/03/2020.
//  Copyright © 2020 Ariel Rodriguez. All rights reserved.
//

import Foundation

enum Currency: String, Codable {
  case USD
}

enum CryptoCurrency: String, Codable {
  case BTC
}

struct Price: Codable {
  let base: CryptoCurrency
  let amount: String
  let currency: Currency
}

extension Price {
  func components() -> (dollars: String?, cents: String?) {
    let tokens = amount.components(separatedBy: ".")
    return (dollars: tokens.first, cents: tokens.last)
  }
}


