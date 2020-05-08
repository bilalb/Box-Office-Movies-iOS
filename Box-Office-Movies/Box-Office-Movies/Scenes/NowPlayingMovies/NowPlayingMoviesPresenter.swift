//
//  NowPlayingMoviesPresenter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import UIKit

protocol NowPlayingMoviesPresentationLogic {
    func presentNowPlayingMovies(response: NowPlayingMovies.FetchNowPlayingMovies.Response)
    func presentFilterMovies(response: NowPlayingMovies.FilterMovies.Response)
    func presentTableViewBackgroundView(response: NowPlayingMovies.LoadTableViewBackgroundView.Response)

    func presentFavoriteMovies(response: NowPlayingMovies.LoadFavoriteMovies.Response)
    func presentRefreshFavoriteMovies(response: NowPlayingMovies.RefreshFavoriteMovies.Response)
}

final class NowPlayingMoviesPresenter {
    typealias MovieListItem = NowPlayingMovies.MovieListItem
    weak var viewController: NowPlayingMoviesDisplayLogic?
}

extension NowPlayingMoviesPresenter: NowPlayingMoviesPresentationLogic {

    func presentNowPlayingMovies(response: NowPlayingMovies.FetchNowPlayingMovies.Response) {
        DispatchQueue.main.async {
            var items = self.movieItems(for: response.movies)

            if case .fetchNextPageError = response.networkError, let mode = response.mode {
                let errorItem = MovieListItem.error(description: NSLocalizedString("genericErrorMessage", comment: "genericErrorMessage"), mode: mode)
                items?.append(errorItem)
            }
            // `.fetchFirstPageError` & `.refreshMovieListError` do not need to append an error item as `items` is empty and the table view background view takes care of displaying the error

            let viewModel = NowPlayingMovies.FetchNowPlayingMovies.ViewModel(movieItems: items)
            self.viewController?.displayNowPlayingMovies(viewModel: viewModel)
        }
    }

    func presentFilterMovies(response: NowPlayingMovies.FilterMovies.Response) {
        let items = movieItems(for: response.movies)
        let viewModel = NowPlayingMovies.FilterMovies.ViewModel(movieItems: items)
        viewController?.displayFilterMovies(viewModel: viewModel)
    }

    func presentTableViewBackgroundView(response: NowPlayingMovies.LoadTableViewBackgroundView.Response) {
        let backgroundView: UIView? = {
            guard
                response.movies?.isEmpty != false,
                let emptyBackgroundView = EmptyBackgroundView.fromNib(named: Constants.NibName.emptyBackgroundView) as? EmptyBackgroundView
            else {
                return nil
            }
            let message: String? = {
                // At the moment, only network errors are handled.
                // That is the reason for the check `response.state == .allMovies`.
                if response.networkError != nil, response.state == .allMovies {
                    return NSLocalizedString("genericErrorMessage", comment: "genericErrorMessage")
                } else {
                    switch response.state {
                    case .allMovies:
                        return NSLocalizedString("noResults", comment: "noResults")
                    case .favorites:
                        return response.searchText?.isEmpty == true ? NSLocalizedString("noFavorites", comment: "noFavorites") : NSLocalizedString("noResults", comment: "noResults")
                    }
                }
            }()

            emptyBackgroundView.message = message

            let shouldDisplayRetryButton = response.state == .allMovies && response.networkError != nil
            emptyBackgroundView.shouldDisplayRetryButton = shouldDisplayRetryButton

            let displayType: EmptyBackgroundView.DisplayType = {
                if response.networkError == nil && response.state == .allMovies {
                    return .loading
                }
                return .message
            }()
            emptyBackgroundView.displayType = displayType

            if let viewController = viewController as? NowPlayingMoviesViewController {
                emptyBackgroundView.retryButtonAction = {
                    viewController.fetchNowPlayingMovies()
                }
            }

            return emptyBackgroundView
        }()

        let isSearchBarEnabled = response.movies?.isEmpty == false
        let viewModel = NowPlayingMovies.LoadTableViewBackgroundView.ViewModel(
            backgroundView: backgroundView,
            isSearchBarEnabled: isSearchBarEnabled)
        viewController?.displayTableViewBackgroundView(viewModel: viewModel)
    }
}

extension NowPlayingMoviesPresenter {

    func movieItems(for movies: [Movie]?) -> [MovieListItem]? {
        return movies?.compactMap { MovieListItem.movie(title: $0.title) }
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

    func presentRefreshFavoriteMovies(response: NowPlayingMovies.RefreshFavoriteMovies.Response) {
        let shouldSetMovieItems = response.state == .favorites
        let items = movieItems(for: response.movies)

        var indexPathsForRowsToDelete: [IndexPath]?
        var indexPathsForRowsToInsert: [IndexPath]?

        switch response.refreshType {
        case .insertion(let index):
            indexPathsForRowsToInsert = [IndexPath(row: index, section: 0)]
        case .deletion(let index):
            indexPathsForRowsToDelete = [IndexPath(row: index, section: 0)]
        case .none:
            break
        }

        let shouldSetRightBarButtonItem = response.state == .favorites
        let rightBarButtonItem: UIBarButtonItem? = items?.isEmpty == true ? nil : response.editButtonItem

        let viewModel = NowPlayingMovies.RefreshFavoriteMovies.ViewModel(shouldSetMovieItems: shouldSetMovieItems,
                                                                         movieItems: items,
                                                                         indexPathsForRowsToDelete: indexPathsForRowsToDelete,
                                                                         indexPathsForRowsToInsert: indexPathsForRowsToInsert, shouldSetRightBarButtonItem: shouldSetRightBarButtonItem,
                                                                         rightBarButtonItem: rightBarButtonItem)
        viewController?.displayRefreshFavoriteMovies(viewModel: viewModel)
    }
}
