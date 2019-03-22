//
//  NetworkRequest.swift
//  Box-Office-Movies
//

import Foundation

struct Environment {
    let baseURL: String
}

class NetworkRequest {
    
    let environment: Environment
    
    init(environment: Environment) {
        self.environment = environment
    }
    
    func urlString() -> String {
        return ""
    }
    
    var urlRequest: URLRequest? {
        let apiKeyParameter = String(format: Constants.Environment.apiKeyParameter, Constants.Environment.apiKey)
        let string = urlString().appending("&\(apiKeyParameter)")
        
        if let url = URL(string: string) {
            return URLRequest(url: url)
        }
        return nil
    }
}
