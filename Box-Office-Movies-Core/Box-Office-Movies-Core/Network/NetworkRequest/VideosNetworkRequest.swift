//
//  VideosNetworkRequest.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 09/08/2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

final class VideosNetworkRequest: NetworkRequest {
    
    let identifier: Int
    let languageCode: String
    
    init(environment: Environment, identifier: Int, languageCode: String) {
        self.identifier = identifier
        self.languageCode = languageCode
        super.init(environment: environment)
    }
    
    override func urlString() -> String {
        let path = String(format: Constants.VideosNetworkRequest.path,
                          identifier,
                          languageCode,
                          environment.theMovieDatabaseAPIKey)
        return environment.theMovieDatabaseAPIBaseUrl.appending(path)
    }
}
