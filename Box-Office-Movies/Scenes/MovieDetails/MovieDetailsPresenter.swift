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
}
