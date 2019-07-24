//
//  NetworkController.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

/// Completion Handler of the network call.
///
/// - Parameters:
///   - data: The data returned by the network call.
///   - response: The response of the network call.
///   - error: The error encountered while executing or validating the request.
typealias NetworkCompletionHandler = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkControlling {
    
    /// Init method of the network controller.
    ///
    /// - Parameters:
    ///   - environment: The environment used to initialise the network requests.
    ///   - session: The URL session to use (Mocked for testing, otherwise default).
    init(environment: Environment, session: URLSession?)
    
    /// Sends a network request and returns with the results
    ///
    /// - Parameters:
    ///   - request: The network request to send.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func send(request: NetworkRequest, completionHandler: NetworkCompletionHandler?)
}

class NetworkController: NetworkControlling {
    
    let environment: Environment
    let session: URLSession?
    
    required init(environment: Environment, session: URLSession?) {
        self.environment = environment
        self.session = session
    }
    
    func send(request: NetworkRequest, completionHandler: NetworkCompletionHandler?) {
        if let urlRequest = request.urlRequest {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            let dataTask = session?.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                completionHandler?(data, response, error)
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            })
            dataTask?.resume()
        }
    }
}
