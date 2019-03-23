//
//  PosterNetworkRequest.swift
//  Box-Office-Movies
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
