//
//  NetworkRequest.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

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
