//
//  TheMovieDatabaseAPIConfigurationNetworkRequest.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

class TheMovieDatabaseAPIConfigurationNetworkRequest: NetworkRequest {
    
    override func urlString() -> String {
        let path = String(format: Constants.TheMovieDatabaseAPIConfigurationNetworkRequest.path,
                          environment.theMovieDatabaseAPIKey)
        return environment.theMovieDatabaseAPIBaseUrl.appending(path)
    }
}
