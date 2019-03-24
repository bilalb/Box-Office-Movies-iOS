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
        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as? SomewhereViewController,
//                var destinationDS = destinationVC.router?.dataStore {
//                passDataToSomewhere(source: dataStore, destination: &destinationDS)
//                navigateToSomewhere(source: viewController, destination: destinationVC)
//            }
        }
    }
}

// MARK: - Private Functions
private extension NowPlayingMoviesRouter {
    
    func passDataToMovieDetails(source: NowPlayingMoviesDataStore, destination: inout MovieDetailsDataStore) {
        var movies = [Movie]()
        source.paginatedMovieLists.forEach({ (paginatedMovieList) in
            paginatedMovieList.movies.forEach({ (movie) in
                movies.append(movie)
            })
        })
        
        guard
            let selectedRow = viewController?.nowPlayingMoviesTableView.indexPathForSelectedRow?.row,
            movies.indices.contains(selectedRow)
        else {
            return
        }
        
        destination.movieIdentifier = movies[selectedRow].identifier
    }
    
//    func navigateToMovieDetails(source: NowPlayingMoviesViewController, destination: MovieDetailsViewController) {
//        source.show(destination, sender: nil)
//    }
}
