//
//  TheMovieDatabaseAPIConfigurationNetworkRequest.swift
//  Box-Office-Movies
//

import Foundation

class TheMovieDatabaseAPIConfigurationNetworkRequest: NetworkRequest {
    
    override func urlString() -> String {
        let path = String(format: Constants.TheMovieDatabaseAPIConfigurationNetworkRequest.path,
                          environment.theMovieDatabaseAPIKey)
        return environment.theMovieDatabaseAPIBaseUrl.appending(path)
    }
}
