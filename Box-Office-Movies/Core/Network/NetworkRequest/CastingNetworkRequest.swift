//
//  CastingNetworkRequest.swift
//  Box-Office-Movies
//

import Foundation

class CastingNetworkRequest: NetworkRequest {
    
    let identifier: Int
    
    init(environment: Environment, identifier: Int) {
        self.identifier = identifier
        super.init(environment: environment)
    }
    
    override func urlString() -> String {
        let path = String(format: Constants.CastingNetworkRequest.path,
                          identifier,
                          environment.theMovieDatabaseAPIKey)
        return environment.theMovieDatabaseAPIBaseUrl.appending(path)
    }
}
