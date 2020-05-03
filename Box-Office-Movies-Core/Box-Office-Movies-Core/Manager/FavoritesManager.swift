//
//  FavoritesManager.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 07.06.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

public protocol FavoritesManagement {
    
    /// Adds the movie to the favorites.
    ///
    /// - Parameter movie: The movie to add to the favorites.
    /// - Returns: `true` if the addition is successfull; otherwise, `false`.
    func addMovieToFavorites(_ movie: Movie) -> Bool
    
    /// Remove the movie from the favorites.
    ///
    /// - Parameter movie: The movie to remove from the favorites.
    /// - Returns: `true` if the removal is successfull; otherwise, `false`.
    func removeMovieFromFavorites(_ movie: Movie) -> Bool
    
    /// The favorite movies.
    ///
    /// - Returns: An array containing the favorite movies.
    func favoriteMovies() -> [Movie]?
}

final class FavoritesManager: FavoritesManagement {
    
    private var dataAccessController: FavoritesDataAccessControlling
    
    init(dataAccessController: FavoritesDataAccessControlling) {
        self.dataAccessController = dataAccessController
    }
    
    func addMovieToFavorites(_ movie: Movie) -> Bool {
        return dataAccessController.addMovieToFavorites(movie)
    }
    
    func removeMovieFromFavorites(_ movie: Movie) -> Bool {
        return dataAccessController.removeMovieFromFavorites(movie)
    }
    
    func favoriteMovies() -> [Movie]? {
        return dataAccessController.favoriteMovies()
    }
}
