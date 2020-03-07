//
//  NetworkTests.swift
//  SwiftIDTests
//
//  Created by Ariel Rodriguez on 06/03/2020.
//  Copyright © 2020 Ariel Rodriguez. All rights reserved.
//

import XCTest
import Swinject

@testable import SwiftID

enum DataSet: String {
    case one
    case two

    static let all: [DataSet] = [.one, .two]
}

extension DataSet {
    var name: String {
        rawValue
    }

    var filename: String {
        "dataset-\(rawValue)"
    }
}

struct NetworkMocks: Networking {
    let filename: String
    func request(from: Endpoint, completion: @escaping CompletionHandler) {
        let data = readJSON(name: filename)
        completion(data, nil)
    }

    private func readJSON(name: String) -> Data? {
        let bundle = Bundle(for: NetworkTests.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            fatalError("Unable to read json file")
        }

        do {
            return try Data(contentsOf: url, options: .mappedIfSafe)
        } catch {
            XCTFail("Error ocurred parsing test data")
            return nil
        }
    }
}

class NetworkTests: XCTestCase {
    private let container = Container()

    override func setUp() {

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDatasetOne() {
        let networking = NetworkMocks(filename: DataSet.one.filename)
        let fetcher = BitcoinPriceFetcher(networking: networking)
        let expectation = XCTestExpectation(description: "Fetch Bitcoin price from dataset one")

        fetcher.fetch { response in
            XCTAssertEqual("100000.01", response!.data.amount)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testDatasetTwo() {
        let networking = NetworkMocks(filename: DataSet.two.filename)
        let fetcher = BitcoinPriceFetcher(networking: networking)
        let expectation = XCTestExpectation(description: "Fetch Bitcoin price from dataset two")

        fetcher.fetch { response in
            XCTAssertEqual("9999999.76", response!.data.amount)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
