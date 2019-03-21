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
        if let url = URL(string: urlString()) {
            return URLRequest(url: url)
        }
        return nil
    }
}
