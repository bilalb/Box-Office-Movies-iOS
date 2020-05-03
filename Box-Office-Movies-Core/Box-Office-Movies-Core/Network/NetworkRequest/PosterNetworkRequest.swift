//
//  PosterNetworkRequest.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

final class PosterNetworkRequest: NetworkRequest {
    
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
