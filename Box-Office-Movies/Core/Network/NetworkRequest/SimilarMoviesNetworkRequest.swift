//
//  SimilarMoviesNetworkRequest.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All right reserved.
//

import Foundation

class SimilarMoviesNetworkRequest: NetworkRequest {
    
    let identifier: Int
    let languageCode: String
    let page: Int
    
    init(environment: Environment, identifier: Int, languageCode: String, page: Int) {
        self.identifier = identifier
        self.languageCode = languageCode
        self.page = page
        super.init(environment: environment)
    }
    
    override func urlString() -> String {
        let path = String(format: Constants.SimilarMoviesNetworkRequest.path,
                          identifier,
                          languageCode,
                          page,
                          environment.theMovieDatabaseAPIKey)
        return environment.theMovieDatabaseAPIBaseUrl.appending(path)
    }
}
