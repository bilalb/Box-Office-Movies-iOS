//
//  NowPlayingMoviesNetworkRequest.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

final class NowPlayingMoviesNetworkRequest: NetworkRequest {
    
    let languageCode: String
    let regionCode: String
    let page: Int
    
    init(environment: Environment, languageCode: String, regionCode: String, page: Int) {
        self.languageCode = languageCode
        self.regionCode = regionCode
        self.page = page
        super.init(environment: environment)
    }
    
    override func urlString() -> String {
        let path = String(format: Constants.NowPlayingMoviesNetworkRequest.path,
                          languageCode,
                          regionCode,
                          page,
                          environment.theMovieDatabaseAPIKey)
        return environment.theMovieDatabaseAPIBaseUrl.appending(path)
    }
}
