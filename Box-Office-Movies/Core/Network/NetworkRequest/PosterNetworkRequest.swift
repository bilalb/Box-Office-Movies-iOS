//
//  PosterNetworkRequest.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All right reserved.
//

import Foundation

class PosterNetworkRequest: NetworkRequest {
    
    let imageSecureBaseURL: String
    let posterSize: String
    let posterPath: String
    
    init(environment: Environment, imageSecureBaseURL: String, posterSize: String, posterPath: String) {
        self.imageSecureBaseURL = imageSecureBaseURL
        self.posterSize = posterSize
        self.posterPath = posterPath
        super.init(environment: environment)
    }
    
    override func urlString() -> String {
        let path = String(format: Constants.PosterNetworkRequest.path,
                          imageSecureBaseURL,
                          posterSize,
                          posterPath)
        return path
    }
}
