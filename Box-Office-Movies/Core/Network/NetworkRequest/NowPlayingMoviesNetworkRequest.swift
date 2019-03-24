//
//  NowPlayingMoviesNetworkRequest.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All right reserved.
//

import Foundation

class NowPlayingMoviesNetworkRequest: NetworkRequest {
    
    let languageCode: String
    let regionCode: String
    let page: Int
    
    init(environment: Environment, languageCode: String, regionCode: String, page: Int) {
        // As a reminder :
        // Locale.current.languageCode
        // Locale.current.regionCode
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
