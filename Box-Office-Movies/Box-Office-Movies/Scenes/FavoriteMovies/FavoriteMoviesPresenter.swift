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
    func presentRemoveMovieFromFavorites(response: FavoriteMovies.RemoveMovieFromFavorites.Response)
}

class FavoriteMoviesPresenter {
    weak var viewController: FavoriteMoviesDisplayLogic?
}

extension FavoriteMoviesPresenter: FavoriteMoviesPresentationLogic {
    
    func presentFavoriteMovies(response: FavoriteMovies.LoadFavoriteMovies.Response) {
        let items = movieItems(for: response.favoriteMovies)
        let viewModel = FavoriteMovies.LoadFavoriteMovies.ViewModel(movieItems: items)
        viewController?.displayFavoriteMovies(viewModel: viewModel)
    }
    
    func presentRemoveMovieFromFavorites(response: FavoriteMovies.RemoveMovieFromFavorites.Response) {
        let items = movieItems(for: response.favoriteMovies)
        let indexPathsForRowsToDelete = [response.indexPathForMovieToRemove]
        let viewModel = FavoriteMovies.RemoveMovieFromFavorites.ViewModel(movieItems: items, indexPathsForRowsToDelete: indexPathsForRowsToDelete)
        viewController?.displayRemoveMovieFromFavorites(viewModel: viewModel)
    }
}

extension FavoriteMoviesPresenter {
    
    func movieItems(for favoriteMovies: [FavoriteMovie]?) -> [MovieItem]? {
        let movieItems = favoriteMovies?.compactMap({ movie -> MovieItem in
            return MovieItem(title: movie.title)
        })
        return movieItems
    }
} 
