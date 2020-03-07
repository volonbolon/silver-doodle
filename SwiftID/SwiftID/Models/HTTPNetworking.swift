//
//  HTTPNetworking.swift
//  SwiftID
//
//  Created by Ariel Rodriguez on 03/03/2020.
//  Copyright © 2020 Ariel Rodriguez. All rights reserved.
//

import Foundation

protocol Networking {
    typealias CompletionHandler = (Data?, Swift.Error?) -> Void

    func request(from: Endpoint, completion: @escaping CompletionHandler)
}

struct HTTPNetworking: Networking {
    func request(from: Endpoint, completion: @escaping Self.CompletionHandler) {
        guard let url = URL(string: from.path) else {
            return
        }
        let request = createRequest(from: url)
        let task = createDataTask(from: request, completionHandler: completion)
        task.resume()
    }

    private func createRequest(from url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringCacheData
        return request
    }

    private func createDataTask(from request: URLRequest,
                                completionHandler: @escaping CompletionHandler) -> URLSessionTask {
        let session = URLSession.shared.dataTask(with: request) { (data, _, error) in
            completionHandler(data, error)
        }
        return session
    }
}
