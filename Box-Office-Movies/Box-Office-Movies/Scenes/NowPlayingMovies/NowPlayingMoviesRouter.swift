//
//  NowPlayingMoviesRouter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol NowPlayingMoviesDataPassing {
    var dataStore: NowPlayingMoviesDataStore? { get }
}

class NowPlayingMoviesRouter: NSObject, NowPlayingMoviesDataPassing {
    weak var viewController: NowPlayingMoviesViewController?
    var dataStore: NowPlayingMoviesDataStore?
}

@objc protocol NowPlayingMoviesRoutingLogic {
    func routeToMovieDetails(segue: UIStoryboardSegue?)
}

extension NowPlayingMoviesRouter: NowPlayingMoviesRoutingLogic {
    
    func routeToMovieDetails(segue: UIStoryboardSegue?) {
        if let segue = segue,
            let destinationVC = (segue.destination as? UINavigationController)?.topViewController as? MovieDetailsViewController,
            var destinationDS = destinationVC.router?.dataStore,
            let dataStore = dataStore {
            passDataToMovieDetails(source: dataStore, destination: &destinationDS)
        }
    }
}

// MARK: - Private Functions
private extension NowPlayingMoviesRouter {
    
    func passDataToMovieDetails(source: NowPlayingMoviesDataStore, destination: inout MovieDetailsDataStore) {
        let movies = source.isFiltering ? source.filteredMovies : source.movies
        
        guard
            let indexForSelectedRow = viewController?.nowPlayingMoviesTableView.indexPathForSelectedRow?.row,
            movies.indices.contains(indexForSelectedRow)
        else {
            return
        }
        
        destination.movieIdentifier = movies[indexForSelectedRow].identifier
    }
}
