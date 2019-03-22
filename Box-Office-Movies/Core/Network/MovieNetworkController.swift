//
//  MovieNetworkController.swift
//  Box-Office-Movies
//

import Foundation

protocol MovieNetworkControlling: NetworkControlling {
    
    /// Fetches the list of movies now playing in theatres.
    ///
    /// - Parameters:
    ///   - languageCode: Language code in ISO 639-1 format.
    ///   - regionCode: Region code in ISO 3166-1 format.
    ///   - page: Page to query.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func nowPlayingMovies(languageCode: String, regionCode: String, page: Int, completionHandler: NowPlayingMoviesCompletionHandler?)
    
    /// Fetches the details of a movie.
    ///
    /// - Parameters:
    ///   - identifier: Identifier of the movie.
    ///   - languageCode: Language code in ISO 639-1 format.
    ///   - regionCode: Region code in ISO 3166-1 format.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func movieDetails(identifier: Int, languageCode: String, regionCode: String, completionHandler: MovieDetailsCompletionHandler?)
}

class MovieNetworkController: NetworkController, MovieNetworkControlling {
    
    func nowPlayingMovies(languageCode: String, regionCode: String, page: Int, completionHandler: NowPlayingMoviesCompletionHandler?) {
        let request = NowPlayingMoviesNetworkRequest(environment: environment,
                                                     languageCode: languageCode,
                                                     regionCode: regionCode,
                                                     page: page)
        send(request: request) { (data, _, error) in
            if let data = data, let movies = try? JSONDecoder().decode([Movie].self, from: data) {
                completionHandler?(movies, nil)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
    
    func movieDetails(identifier: Int, languageCode: String, regionCode: String, completionHandler: MovieDetailsCompletionHandler?) {
        let request = MovieDetailsNetworkRequest(environment: environment,
                                                 identifier: identifier,
                                                 languageCode: languageCode,
                                                 regionCode: regionCode)
        send(request: request) { (data, _, error) in
            if let data = data, let movieDetails = try? JSONDecoder().decode(MovieDetails.self, from: data) {
                completionHandler?(movieDetails, nil)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
}
