//
//  Error.swift
//  SwiftID
//
//  Created by Ariel Rodriguez on 03/03/2020.
//  Copyright © 2020 Ariel Rodriguez. All rights reserved.
//

import Foundation

struct Error: Codable {
  let id: String
  let message: String
  let url: String
}
