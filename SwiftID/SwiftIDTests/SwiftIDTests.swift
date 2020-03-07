//
//  SwiftIDTests.swift
//  SwiftIDTests
//
//  Created by Ariel Rodriguez on 03/03/2020.
//  Copyright © 2020 Ariel Rodriguez. All rights reserved.
//

import XCTest
import Swinject

@testable import SwiftID

class SwiftIDTests: XCTestCase {
    private let container = Container()

    override func setUp() {
        super.setUp()

        container.register(Currency.self) { _ in
            .USD
        }

        container.register(CryptoCurrency.self) { _ in
            .BTC
        }

        container.register(Price.self) { (resolver) -> Price in
            guard let crypto = resolver.resolve(CryptoCurrency.self),
                let currency = resolver.resolve(Currency.self) else {
                fatalError("Unable to resolve Crypto or currency")
            }
            return Price(base: crypto, amount: "999456", currency: currency)
        }

        container.register(PriceResponse.self) { (resolver) -> PriceResponse in
            guard let price = resolver.resolve(Price.self) else {
                fatalError("Unable to resolve price")
            }
            return PriceResponse(data: price, warnings: nil)
        }
    }

    override func tearDown() {
        super.tearDown()
        container.removeAll()
    }

    func testPriceResponseData() {
        guard let response = container.resolve(PriceResponse.self) else {
            fatalError("Unable to resolve Price Response")
        }
        XCTAssertEqual(response.data.amount, "999456")
    }
}
