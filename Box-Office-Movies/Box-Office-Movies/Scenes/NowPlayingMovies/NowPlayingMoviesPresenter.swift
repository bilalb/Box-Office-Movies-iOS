//
//  NowPlayingMoviesPresenter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import UIKit

protocol NowPlayingMoviesPresentationLogic {
    func presentNowPlayingMovies(response: NowPlayingMovies.FetchNowPlayingMovies.Response)
    func presentNextPage(response: NowPlayingMovies.FetchNextPage.Response)
    func presentFilterMovies(response: NowPlayingMovies.FilterMovies.Response)
    func presentRefreshMovies(response: NowPlayingMovies.RefreshMovies.Response)
    func presentTableViewBackgroundView(response: NowPlayingMovies.LoadTableViewBackgroundView.Response)

    func presentFavoriteMovies(response: NowPlayingMovies.LoadFavoriteMovies.Response)
    func presentRemoveMovieFromFavorites(response: NowPlayingMovies.RemoveMovieFromFavorites.Response)
}

class NowPlayingMoviesPresenter {
    weak var viewController: NowPlayingMoviesDisplayLogic?
}

extension NowPlayingMoviesPresenter: NowPlayingMoviesPresentationLogic {
    
    func presentNowPlayingMovies(response: NowPlayingMovies.FetchNowPlayingMovies.Response) {
        DispatchQueue.main.async {
            let items = self.movieItems(for: response.movies)
            let shouldHideErrorView = response.error == nil
            let errorDescription = response.error?.localizedDescription
            let viewModel = NowPlayingMovies.FetchNowPlayingMovies.ViewModel(movieItems: items,
                                                                             shouldHideErrorView: shouldHideErrorView,
                                                                             errorDescription: errorDescription)
            self.viewController?.displayNowPlayingMovies(viewModel: viewModel)
        }
    }
    
    func presentNextPage(response: NowPlayingMovies.FetchNextPage.Response) {
        DispatchQueue.main.async {
            let items = self.movieItems(for: response.movies)
            let shouldPresentErrorAlert = response.error != nil
            let errorAlertMessage = response.error?.localizedDescription
            let errorAlertActions = [UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel)]
            let viewModel = NowPlayingMovies.FetchNextPage.ViewModel(movieItems: items,
                                                                     shouldPresentErrorAlert: shouldPresentErrorAlert,
                                                                     errorAlertTitle: nil,
                                                                     errorAlertMessage: errorAlertMessage,
                                                                     errorAlertStyle: .alert,
                                                                     errorAlertActions: errorAlertActions)
            self.viewController?.displayNextPage(viewModel: viewModel)
        }
    }
    
    func presentFilterMovies(response: NowPlayingMovies.FilterMovies.Response) {
        let items = movieItems(for: response.movies)
        let viewModel = NowPlayingMovies.FilterMovies.ViewModel(movieItems: items)
        viewController?.displayFilterMovies(viewModel: viewModel)
    }
    
    func presentRefreshMovies(response: NowPlayingMovies.RefreshMovies.Response) {
        DispatchQueue.main.async {
            let items = self.movieItems(for: response.movies)
            let shouldPresentErrorAlert = response.error != nil
            let errorAlertMessage = response.error?.localizedDescription
            let errorAlertActions = [UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel)]
            let viewModel = NowPlayingMovies.RefreshMovies.ViewModel(movieItems: items,
                                                                     shouldPresentErrorAlert: shouldPresentErrorAlert,
                                                                     errorAlertTitle: nil,
                                                                     errorAlertMessage: errorAlertMessage,
                                                                     errorAlertStyle: .alert,
                                                                     errorAlertActions: errorAlertActions)
            self.viewController?.displayRefreshMovies(viewModel: viewModel)
        }
    }
    
    func presentTableViewBackgroundView(response: NowPlayingMovies.LoadTableViewBackgroundView.Response) {
        let backgroundView: UIView? = {
            guard
                response.movies?.isEmpty == true,
                let emptyBackgroundView = EmptyBackgroundView.fromNib(named: Constants.NibName.emptyBackgroundView) as? EmptyBackgroundView
            else {
                return nil
            }
            let message: String? = {
                switch response.state {
                case .allMovies:
                    return NSLocalizedString("noResults", comment: "noResults")
                case .favorites:
                    return response.searchText?.isEmpty == true ? NSLocalizedString("noFavorites", comment: "noFavorites") : NSLocalizedString("noResults", comment: "noResults")
                }
            }()
            emptyBackgroundView.message = message
            return emptyBackgroundView
        }()
        let viewModel = NowPlayingMovies.LoadTableViewBackgroundView.ViewModel(backgroundView: backgroundView)
        viewController?.displayTableViewBackgroundView(viewModel: viewModel)
    }
}

extension NowPlayingMoviesPresenter {
    
    func movieItems(for movies: [Movie]?) -> [MovieItem]? {
        let movieItems = movies?.compactMap({ movie -> MovieItem in
            return MovieItem(title: movie.title)
        })
        return movieItems
    }
}

// MARK: - Favorite movies

extension NowPlayingMoviesPresenter {
    
    func presentFavoriteMovies(response: NowPlayingMovies.LoadFavoriteMovies.Response) {
        let items = movieItems(for: response.movies)
        let rightBarButtonItem: UIBarButtonItem? = items?.isEmpty == true ? nil : response.editButtonItem
        let viewModel = NowPlayingMovies.LoadFavoriteMovies.ViewModel(movieItems: items, rightBarButtonItem: rightBarButtonItem, refreshControl: nil)
        viewController?.displayFavoriteMovies(viewModel: viewModel)
    }
    
    func presentRemoveMovieFromFavorites(response: NowPlayingMovies.RemoveMovieFromFavorites.Response) {
        let items = movieItems(for: response.movies)
        let indexPathsForRowsToDelete = [response.indexPathForMovieToRemove]
        let rightBarButtonItem: UIBarButtonItem? = items?.isEmpty == true ? nil : response.editButtonItem
        let viewModel = NowPlayingMovies.RemoveMovieFromFavorites.ViewModel(movieItems: items, indexPathsForRowsToDelete: indexPathsForRowsToDelete, rightBarButtonItem: rightBarButtonItem)
        viewController?.displayRemoveMovieFromFavorites(viewModel: viewModel)
    }
}
