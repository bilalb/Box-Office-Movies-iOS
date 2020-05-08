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
    let isRefreshing: Bool
    
    init(environment: Environment, isRefreshing: Bool = false) {
        self.environment = environment
        self.isRefreshing = isRefreshing
    }
    
    func urlString() -> String {
        return ""
    }
    
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString()) {
            let cachePolicy: URLRequest.CachePolicy = isRefreshing ? .reloadIgnoringLocalCacheData : .useProtocolCachePolicy
            return URLRequest(url: url, cachePolicy: cachePolicy)
        }
        return nil
    }
}
