//
//  NowPlayingMoviesNetworkRequest.swift
//  Box-Office-Movies
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
                          page)
        return environment.baseURL.appending(path)
    }
}
