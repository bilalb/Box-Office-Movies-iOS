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
    ///   - environment: The environment to used to initialise the network requests.
    init(environment: Environment)
    
    /// Sends a network request and returns with the results
    ///
    /// - Parameters:
    ///   - request: The network request to send.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func send(request: NetworkRequest, completionHandler: NetworkCompletionHandler?)
}

class NetworkController: NetworkControlling {
    
    let environment: Environment
    let defaultSession: URLSession?
    
    required init(environment: Environment) {
        defaultSession = URLSession(configuration: .default)
        defaultSession?.configuration.timeoutIntervalForRequest = Constants.Network.timeoutIntervalForRequest
        defaultSession?.configuration.timeoutIntervalForResource = Constants.Network.timeoutIntervalForResource
        self.environment = environment
    }
    
    func send(request: NetworkRequest, completionHandler: NetworkCompletionHandler?) {
        if let urlRequest = request.urlRequest {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            let dataTask = defaultSession?.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                completionHandler?(data, response, error)
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            })
            dataTask?.resume()
        }
    }
}
