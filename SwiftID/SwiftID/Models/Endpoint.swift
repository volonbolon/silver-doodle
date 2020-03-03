//
//  Endpoint.swift
//  SwiftID
//
//  Created by Ariel Rodriguez on 03/03/2020.
//  Copyright © 2020 Ariel Rodriguez. All rights reserved.
//

import Foundation

protocol Endpoint {
  var path: String { get }
}

enum Coinbase {
  case bitcoin
}

extension Coinbase: Endpoint {
  var path: String {
    switch self {
    case .bitcoin: return "https://api.coinbase.com/v2/prices/BTC-USD/spot"
    }
  }
}
