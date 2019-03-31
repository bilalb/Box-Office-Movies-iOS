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
            
            var additionalInformationItem: DetailItem {
                let releaseDate = "Release date\n\(movieDetails.releaseDate)"
                let voteAverage = "Average vote\n\(movieDetails.formattedVoteAverage)"
                return DetailItem.additionalInformation(posterImage: response.posterImage, releaseDate: releaseDate, voteAverage: voteAverage)
            }
            
            let reviewMovieItem = DetailItem.reviewMovie(review: "Review")
            let synopsisItem = DetailItem.synopsis(synopsis: movieDetails.synopsis)
            
            var castingItem: DetailItem {
                var actors = ""
                response.casting?.actors.forEach({ (actor) in
                    actors.append(withSeparator: ", ", other: actor.name)
                })
                return DetailItem.casting(actors: actors)
            }
            
            var similarMoviesItem: DetailItem {
                var similarMovies = ""
                response.paginatedSimilarMovieLists?.forEach({ (paginatedSimilarMovieList) in
                    paginatedSimilarMovieList.movies.forEach({ (movie) in
                        similarMovies.append(withSeparator: ", ", other: movie.title)
                    })
                })
                return DetailItem.similarMovies(similarMovies: similarMovies)
            }
            
            let detailItems = [titleItem, additionalInformationItem, reviewMovieItem, synopsisItem, castingItem, similarMoviesItem]
            let viewModel = MovieDetailsScene.FetchMovieDetails.ViewModel(detailItems: detailItems)
            self.viewController?.displayMovieDetails(viewModel: viewModel)
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
        let reviewMovieItem = DetailItem.reviewMovie(review: response.movieReview.description)
        let viewModel = MovieDetailsScene.ReviewMovie.ViewModel(reviewMovieItem: reviewMovieItem)
        viewController?.displayReviewMovie(viewModel: viewModel)
    }
}

extension MovieDetails {
    
    /// Vote average represented with stars
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
