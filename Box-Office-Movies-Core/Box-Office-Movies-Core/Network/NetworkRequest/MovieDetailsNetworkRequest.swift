//
//  MovieDetailsNetworkRequest.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

class MovieDetailsNetworkRequest: NetworkRequest {
    
    let identifier: Int
    let languageCode: String
    let regionCode: String
    
    init(environment: Environment, identifier: Int, languageCode: String, regionCode: String) {
        self.identifier = identifier
        self.languageCode = languageCode
        self.regionCode = regionCode
        super.init(environment: environment)
    }
    
    override func urlString() -> String {
        let path = String(format: Constants.MovieDetailsNetworkRequest.path,
                          identifier,
                          languageCode,
                          regionCode,
                          environment.theMovieDatabaseAPIKey)
        return environment.theMovieDatabaseAPIBaseUrl.appending(path)
    }
}
