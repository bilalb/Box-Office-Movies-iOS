//
//  CastingNetworkRequest.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

final class CastingNetworkRequest: NetworkRequest {
    
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
