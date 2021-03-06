//
//  TheMovieDatabaseAPIConfigurationNetworkRequest.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

final class TheMovieDatabaseAPIConfigurationNetworkRequest: NetworkRequest {
    
    override func urlString() -> String {
        let path = String(format: Constants.TheMovieDatabaseAPIConfigurationNetworkRequest.path,
                          environment.theMovieDatabaseAPIKey)
        return environment.theMovieDatabaseAPIBaseUrl.appending(path)
    }
}
