//
//  MovieNetworkController.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All right reserved.
//

import Foundation
import UIKit

protocol MovieNetworkControlling: NetworkControlling {
    
    /// Fetches the list of movies now playing in theatres.
    ///
    /// - Parameters:
    ///   - languageCode: Language code in ISO 639-1 format.
    ///   - regionCode: Region code in ISO 3166-1 format.
    ///   - page: Page to query (minimum: 1, maximum: 1000).
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
    func poster(imageSecureBaseURL: String, posterSize: String, posterPath: String, completionHandler: PosterCompletionHandler?)
    
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
    ///   - page: Page to query (minimum: 1, maximum: 1000).
    ///   - completionHandler: The completion handler to call when the request is complete.
    func similarMovies(identifier: Int, languageCode: String, page: Int, completionHandler: SimilarMoviesCompletionHandler?)
}

class MovieNetworkController: NetworkController, MovieNetworkControlling {
    
    func nowPlayingMovies(languageCode: String, regionCode: String, page: Int, completionHandler: NowPlayingMoviesCompletionHandler?) {
        let request = NowPlayingMoviesNetworkRequest(environment: environment,
                                                     languageCode: languageCode,
                                                     regionCode: regionCode,
                                                     page: page)
        send(request: request) { (data, _, error) in
            if let data = data, let paginatedMovieList = try? JSONDecoder().decode(PaginatedMovieList.self, from: data) {
                completionHandler?(paginatedMovieList, nil)
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
    
    func theMovieDatabaseAPIConfiguration(completionHandler: TheMovieDatabaseAPIConfigurationCompletionHandler?) {
        let request = TheMovieDatabaseAPIConfigurationNetworkRequest(environment: environment)
        send(request: request) { (data, _, error) in
            if let data = data, let configuration = try? JSONDecoder().decode(TheMovieDatabaseAPIConfiguration.self, from: data) {
                completionHandler?(configuration, nil)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
    
    func poster(imageSecureBaseURL: String, posterSize: String, posterPath: String, completionHandler: PosterCompletionHandler?) {
        let request = PosterNetworkRequest(environment: environment,
                                           imageSecureBaseURL: imageSecureBaseURL,
                                           posterSize: posterSize,
                                           posterPath: posterPath)
        send(request: request) { (data, _, error) in
            if let data = data {
                let image = UIImage(data: data)
                completionHandler?(image, nil)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
    
    func casting(identifier: Int, completionHandler: CastingCompletionHandler?) {
        let request = CastingNetworkRequest(environment: environment, identifier: identifier)
        send(request: request) { (data, _, error) in
            if let data = data, let casting = try? JSONDecoder().decode(Casting.self, from: data) {
                completionHandler?(casting, nil)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
    
    func similarMovies(identifier: Int, languageCode: String, page: Int, completionHandler: SimilarMoviesCompletionHandler?) {
        let request = SimilarMoviesNetworkRequest(environment: environment, identifier: identifier, languageCode: languageCode, page: page)
        send(request: request) { (data, _, error) in
            if let data = data, let paginatedMovieList = try? JSONDecoder().decode(PaginatedMovieList.self, from: data) {
                completionHandler?(paginatedMovieList, nil)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
}
