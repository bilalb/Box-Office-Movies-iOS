//
//  MovieManager.swift
//  Box-Office-Movies
//

import Foundation

/// Completion handler of the movies now playing in theatres.
///
/// - Parameters:
///   - movies: The movies returned by the call.
///   - error: The error encountered while executing or validating the request.
typealias NowPlayingMoviesCompletionHandler = (_ movies: [Movie]?, _ error: Error?) -> Void

/// Completion handler of the movie details.
///
/// - Parameters:
///   - movieDetails: The movie details returned by the call.
///   - error: The error encountered while executing or validating the request.
typealias MovieDetailsCompletionHandler = (_ movieDetails: MovieDetails?, _ error: Error?) -> Void

protocol MovieManagement {
    
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

final class MovieManager: MovieManagement {
    
    private var networkController: MovieNetworkControlling
    
    init(networkController: MovieNetworkControlling) {
        self.networkController = networkController
    }
    
    func nowPlayingMovies(languageCode: String, regionCode: String, page: Int, completionHandler: NowPlayingMoviesCompletionHandler?) {
        networkController.nowPlayingMovies(languageCode: languageCode, regionCode: regionCode, page: page) { (movies, error) in
            completionHandler?(movies, error)
        }
    }
    
    func movieDetails(identifier: Int, languageCode: String, regionCode: String, completionHandler: MovieDetailsCompletionHandler?) {
        networkController.movieDetails(identifier: identifier, languageCode: languageCode, regionCode: regionCode) { (movieDetails, error) in
            completionHandler?(movieDetails, error)
        }
    }
}
