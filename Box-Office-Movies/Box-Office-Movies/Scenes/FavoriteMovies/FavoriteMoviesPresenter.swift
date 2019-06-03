//
//  FavoriteMoviesPresenter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 27.05.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol FavoriteMoviesPresentationLogic {
    func presentFavoriteMovies(response: FavoriteMovies.LoadFavoriteMovies.Response)
}

class FavoriteMoviesPresenter {
    weak var viewController: FavoriteMoviesDisplayLogic?
}

extension FavoriteMoviesPresenter: FavoriteMoviesPresentationLogic {
    
    func presentFavoriteMovies(response: FavoriteMovies.LoadFavoriteMovies.Response) {
        let movieItems = response.favoriteMovies?.compactMap({ movie -> MovieItem in
            return MovieItem(title: movie.title)
        })
        let viewModel = FavoriteMovies.LoadFavoriteMovies.ViewModel(movieItems: movieItems)
        viewController?.displayFavoriteMovies(viewModel: viewModel)
    }
} 
