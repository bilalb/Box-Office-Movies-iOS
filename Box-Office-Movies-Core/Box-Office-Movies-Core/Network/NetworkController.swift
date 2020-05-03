//
//  NetworkController.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

/// Completion Handler of the network call.
///
/// - Parameters:
///   - data: The data returned by the network call.
///   - response: The response of the network call.
///   - error: The error encountered while executing or validating the request.
typealias NetworkCompletionHandler = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkSession {

    /// Sends a network request and returns with the results
    ///
    /// - Parameters:
    ///   - request: The network request to send.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func send(request: NetworkRequest, completionHandler: NetworkCompletionHandler?)
}

extension URLSession: NetworkSession {

    func send(request: NetworkRequest, completionHandler: NetworkCompletionHandler?) {
        guard let urlRequest = request.urlRequest else { return }

        let dataTask = self.dataTask(with: urlRequest) { (data, response, error) in
            completionHandler?(data, response, error)
        }

        dataTask.resume()
    }
}

class NetworkController {

    let environment: Environment
    let session: NetworkSession

    required init(environment: Environment, session: NetworkSession) {
        self.environment = environment
        self.session = session
    }

    func send(request: NetworkRequest, completionHandler: NetworkCompletionHandler?) {
        session.send(request: request, completionHandler: completionHandler)
    }
}
