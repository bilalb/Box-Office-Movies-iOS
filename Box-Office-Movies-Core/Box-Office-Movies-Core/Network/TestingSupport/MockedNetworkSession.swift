//
//  MockedNetworkSession.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 09/01/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

final class MockedNetworkSession: NetworkSession {

    func send(request: NetworkRequest, completionHandler: NetworkCompletionHandler?) {
        let data: Data? = {
            let jsonString: String? = {
                if request.urlRequest?.url?.absoluteString.contains("movie/now_playing?language=") == true {
                    return Constants.Mock.NowPlayingMoviesNetworkRequest.jsonString
                } else if request.urlRequest?.url?.absoluteString.contains("movie/") == true && request.urlRequest?.url?.absoluteString.contains("?language=") == true && request.urlRequest?.url?.absoluteString.contains("&region=") == true && request.urlRequest?.url?.absoluteString.contains("&api_key=") == true {
                    return Constants.Mock.MovieDetailsNetworkRequest.jsonString
                } else if request.urlRequest?.url?.absoluteString.contains("configuration?api_key=") == true {
                    return Constants.Mock.TheMovieDatabaseAPIConfigurationNetworkRequest.jsonString
                } else if request.urlRequest?.url?.absoluteString.contains("/credits?api_key=") == true {
                    return Constants.Mock.CastingNetworkRequest.jsonString
                } else if request.urlRequest?.url?.absoluteString.contains("/similar?language=") == true {
                    return Constants.Mock.SimilarMoviesNetworkRequest.jsonString
                } else if request.urlRequest?.url?.absoluteString.contains("https://image.tmdb.org/t/p/") == true {
                    return Constants.Mock.PosterNetworkRequest.jsonString
                } else if request.urlRequest?.url?.absoluteString.contains("/videos?language=") == true {
                    return Constants.Mock.VideosNetworkRequest.jsonString
                }
                return nil
            }()

            return jsonString?.data(using: .utf8)
        }()

        let response: URLResponse? = {
            return nil
        }()

        let error: Error? = {
            return nil
        }()

        completionHandler?(data, response, error)
    }
}
