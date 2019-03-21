//
//  NetworkController.swift
//  Box-Office-Movies
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
    var dataTask: URLSessionDataTask?
    
    required init(environment: Environment) {
        defaultSession = URLSession(configuration: .default)
        self.environment = environment
    }
    
    func send(request: NetworkRequest, completionHandler: NetworkCompletionHandler?) {
        dataTask?.cancel()
        if let urlRequest = request.urlRequest {
            dataTask = defaultSession?.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                defer {
                    self.dataTask = nil
                }
                completionHandler?(data, response, error)
            })
            dataTask?.resume()
        }
    }
}
