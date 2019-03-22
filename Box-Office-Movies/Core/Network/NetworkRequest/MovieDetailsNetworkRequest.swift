//
//  MovieDetailsNetworkRequest.swift
//  Box-Office-Movies
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
                          regionCode)
        return environment.baseURL.appending(path)
    }
}
