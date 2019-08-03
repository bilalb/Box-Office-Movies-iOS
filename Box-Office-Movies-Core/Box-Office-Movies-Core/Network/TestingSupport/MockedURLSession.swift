//
//  MockedURLSession.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 23.07.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

class MockedURLSession: URLSession {
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data: Data? = {
            let jsonString: String? = {
                if request.url?.absoluteString.contains("movie/now_playing?language=") == true {
                    return Constants.Mock.NowPlayingMoviesNetworkRequest.jsonString
                } else if request.url?.absoluteString.contains("movie/") == true && request.url?.absoluteString.contains("?language=") == true && request.url?.absoluteString.contains("&region=") == true && request.url?.absoluteString.contains("&api_key=") == true {
                    return Constants.Mock.MovieDetailsNetworkRequest.jsonString
                } else if request.url?.absoluteString.contains("configuration?api_key=") == true {
                    return Constants.Mock.TheMovieDatabaseAPIConfigurationNetworkRequest.jsonString
                } else if request.url?.absoluteString.contains("/credits?api_key=") == true {
                    return Constants.Mock.CastingNetworkRequest.jsonString
                } else if request.url?.absoluteString.contains("/similar?language=") == true {
                    return Constants.Mock.SimilarMoviesNetworkRequest.jsonString
                } else if request.url?.absoluteString.contains("https://image.tmdb.org/t/p/") == true {
                    return Constants.Mock.PosterNetworkRequest.jsonString
                }
                return nil
            }()
            
            return jsonString?.data(using: .utf8)
        }()
        
        let urlResponse: URLResponse? = {
            return nil
        }()
        
        let error: Error? = {
            return nil
        }()
        
        let dataTask = MockedURLSessionDataTask(completionHandler: completionHandler, data: data, urlResponse: urlResponse, error: error)
        return dataTask
    }
}
