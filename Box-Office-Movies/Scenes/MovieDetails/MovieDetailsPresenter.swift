//
//  MovieDetailsPresenter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol MovieDetailsPresentationLogic {
    func presentMovieDetails(response: MovieDetailsScene.FetchMovieDetails.Response)
    func presentCasting(response: MovieDetailsScene.FetchCasting.Response)
    func presentSimilarMovies(response: MovieDetailsScene.FetchSimilarMovies.Response)
    func presentMovieReviews(response: MovieDetailsScene.LoadMovieReviews.Response)
    func presentReviewMovie(response: MovieDetailsScene.ReviewMovie.Response)
}

class MovieDetailsPresenter {
    weak var viewController: MovieDetailsDisplayLogic?
}

extension MovieDetailsPresenter: MovieDetailsPresentationLogic {
    
    func presentMovieDetails(response: MovieDetailsScene.FetchMovieDetails.Response) {
        DispatchQueue.main.async {
            guard let movieDetails = response.movieDetails else {
                return
            }
            
            let titleItem = DetailItem.title(title: movieDetails.title)
            
            var posterImageURL: URL? {
                if let posterPath = movieDetails.posterPath, let apiConfiguration = response.apiConfiguration {
                    var posterImagePath = apiConfiguration.imageData.secureBaseUrl
                    posterImagePath.append(Constants.Fallback.posterImageSize)
                    posterImagePath.append(posterPath)
                    
                    return URL(string: posterImagePath)
                } else {
                    return nil
                }
            }
            let additionalInformationItem = DetailItem.additionalInformation(posterImageURL: posterImageURL, releaseDate: movieDetails.releaseDate, voteAverage: movieDetails.formattedVoteAverage)
            
            let reviewMovieItem = DetailItem.reviewMovie
            let synopsisItem = DetailItem.synopsis(synopsis: movieDetails.synopsis)
            let basicItems = [titleItem, additionalInformationItem, reviewMovieItem, synopsisItem]
            let viewModel = MovieDetailsScene.FetchMovieDetails.ViewModel(basicItems: basicItems)
            self.viewController?.displayMovieDetails(viewModel: viewModel)
        }
    }
    
    func presentCasting(response: MovieDetailsScene.FetchCasting.Response) {
        DispatchQueue.main.async {
            var actors = ""
            response.casting?.actors.forEach({ (actor) in
                actors.append(withSeparator: ", ", other: actor.name)
            })
            let castingItem = DetailItem.casting(actors: actors)
            let viewModel = MovieDetailsScene.FetchCasting.ViewModel(castingItem: castingItem)
            self.viewController?.displayCasting(viewModel: viewModel)
        }
    }
    
    func presentSimilarMovies(response: MovieDetailsScene.FetchSimilarMovies.Response) {
        DispatchQueue.main.async {
            var similarMovies = ""
            response.paginatedMovieLists?.forEach({ (paginatedMovieList) in
                paginatedMovieList.movies.forEach({ (movie) in
                    similarMovies.append(withSeparator: ", ", other: movie.title)
                })
            })
            let similarMoviesItem = DetailItem.similarMovies(similarMovies: similarMovies)
            let viewModel = MovieDetailsScene.FetchSimilarMovies.ViewModel(similarMoviesItem: similarMoviesItem)
            self.viewController?.displaySimilarMovies(viewModel: viewModel)
        }
    }
    
    func presentMovieReviews(response: MovieDetailsScene.LoadMovieReviews.Response) {
        var actions = response.movieReviews.compactMap { (movieReview) -> (UIAlertAction, MovieReview?) in
            let alertAction = UIAlertAction(title: movieReview.description, style: .default, handler: nil)
            return (alertAction, movieReview)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actions.append((cancelAction, nil))
        let viewModel = MovieDetailsScene.LoadMovieReviews.ViewModel(alertControllerTitle: "Review the movie", alertControllerMessage: nil, alertControllerPreferredStyle: .actionSheet, actions: actions)
        viewController?.displayMovieReviews(viewModel: viewModel)
    }
    
    func presentReviewMovie(response: MovieDetailsScene.ReviewMovie.Response) {
        let viewModel = MovieDetailsScene.ReviewMovie.ViewModel()
        viewController?.displayReviewMovie(viewModel: viewModel)
    }
}

extension MovieDetails {
    
    var formattedVoteAverage: String {
        let numberOfStars = 5
        let highestPossibleValueOfVoteAverage = 10
        let numberOfFullStars: Int = Int(voteAverage) * numberOfStars / highestPossibleValueOfVoteAverage
        let numberOfEmptyStars = numberOfStars - numberOfFullStars
        var stars = ""
        for _ in 0 ..< numberOfFullStars {
            stars.append("★")
        }
        for _ in 0 ..< numberOfEmptyStars {
            stars.append("☆")
        }
        return stars
    }
}
