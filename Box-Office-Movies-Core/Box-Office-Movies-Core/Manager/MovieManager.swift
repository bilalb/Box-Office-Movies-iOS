//
//  MovieManager.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

/// Completion handler of the movies now playing in theatres.
///
/// - Parameters:
///   - paginatedMovieList: The response returned by the call.
///   - error: The error encountered while executing or validating the request.
public typealias NowPlayingMoviesCompletionHandler = (_ paginatedMovieList: PaginatedMovieList?, _ error: Error?) -> Void

/// Completion handler of the movie details.
///
/// - Parameters:
///   - movieDetails: The movie details returned by the call.
///   - error: The error encountered while executing or validating the request.
public typealias MovieDetailsCompletionHandler = (_ movieDetails: MovieDetails?, _ error: Error?) -> Void

/// Completion handler of the data for the poster.
///
/// - Parameters:
///   - poster: The data for the poster returned by the call.
///   - error: The error encountered while executing or validating the request.
public typealias PosterDataCompletionHandler = (_ posterData: Data?, _ error: Error?) -> Void

/// Completion handler of the configuration of The Movie Database API.
///
/// - Parameters:
///   - configuration: The configuration returned by the call.
///   - error: The error encountered while executing or validating the request.
public typealias TheMovieDatabaseAPIConfigurationCompletionHandler = (_ configuration: TheMovieDatabaseAPIConfiguration?, _ error: Error?) -> Void

/// Completion handler of the casting of a movie.
///
/// - Parameters:
///   - casting: The casting returned by the call.
///   - error: The error encountered while executing or validating the request.
public typealias CastingCompletionHandler = (_ casting: Casting?, _ error: Error?) -> Void

/// Completion handler of the similar movies.
///
/// - Parameters:
///   - paginatedSimilarMovieList: The response returned by the call.
///   - error: The error encountered while executing or validating the request.
public typealias SimilarMoviesCompletionHandler = (_ paginatedSimilarMovieList: PaginatedMovieList?, _ error: Error?) -> Void

public protocol MovieManagement {
    
    /// Fetches the list of movies now playing in theatres.
    ///
    /// - Parameters:
    ///   - languageCode: Language code in ISO 639-1 format.
    ///   - regionCode: Region code in ISO 3166-1 format.
    ///   - page: Page to query (minimum: `1`, maximum: `1000`).
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
    
    /// Fetches the configuration of The Movie Database API.
    ///
    /// - Parameters:
    ///   - completionHandler: The completion handler to call when the request is complete.
    func theMovieDatabaseAPIConfiguration(completionHandler: TheMovieDatabaseAPIConfigurationCompletionHandler?)
    
    /// Fetches the poster of a movie.
    ///
    /// - Parameters:
    ///   - imageSecureBaseURL: Image secure base url.
    ///   - posterSize: Size of the poster to request.
    ///   - posterPath: Path to the poster.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func poster(imageSecureBaseURL: String, posterSize: String, posterPath: String, completionHandler: PosterDataCompletionHandler?)
    
    /// Fetches the casting of a movie.
    ///
    /// - Parameters:
    ///   - identifier: Identifier of the movie.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func casting(identifier: Int, completionHandler: CastingCompletionHandler?)
    
    /// Fetches the list of similar movies.
    ///
    /// - Parameters:
    ///   - identifier: Identifier of the movie.
    ///   - languageCode: Language code in ISO 639-1 format.
    ///   - page: Page to query (minimum: `1`, maximum: `1000`).
    ///   - completionHandler: The completion handler to call when the request is complete.
    func similarMovies(identifier: Int, languageCode: String, page: Int, completionHandler: SimilarMoviesCompletionHandler?)
}

final class MovieManager: MovieManagement {
    
    private var networkController: MovieNetworkControlling
    
    init(networkController: MovieNetworkControlling) {
        self.networkController = networkController
    }
    
    func nowPlayingMovies(languageCode: String, regionCode: String, page: Int, completionHandler: NowPlayingMoviesCompletionHandler?) {
        networkController.nowPlayingMovies(languageCode: languageCode, regionCode: regionCode, page: page, completionHandler: completionHandler)
    }
    
    func movieDetails(identifier: Int, languageCode: String, regionCode: String, completionHandler: MovieDetailsCompletionHandler?) {
        networkController.movieDetails(identifier: identifier, languageCode: languageCode, regionCode: regionCode, completionHandler: completionHandler)
    }
    
    func theMovieDatabaseAPIConfiguration(completionHandler: TheMovieDatabaseAPIConfigurationCompletionHandler?) {
        networkController.theMovieDatabaseAPIConfiguration(completionHandler: completionHandler)
    }
    
    func poster(imageSecureBaseURL: String, posterSize: String, posterPath: String, completionHandler: PosterDataCompletionHandler?) {
        networkController.poster(imageSecureBaseURL: imageSecureBaseURL, posterSize: posterSize, posterPath: posterPath, completionHandler: completionHandler)
    }
    
    func casting(identifier: Int, completionHandler: CastingCompletionHandler?) {
        networkController.casting(identifier: identifier, completionHandler: completionHandler)
    }
    
    func similarMovies(identifier: Int, languageCode: String, page: Int, completionHandler: SimilarMoviesCompletionHandler?) {
        networkController.similarMovies(identifier: identifier, languageCode: languageCode, page: page, completionHandler: completionHandler)
    }
}
