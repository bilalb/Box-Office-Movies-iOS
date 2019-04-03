//
//  NowPlayingMoviesPresenter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol NowPlayingMoviesPresentationLogic {
    func presentNowPlayingMovies(response: NowPlayingMovies.FetchNowPlayingMovies.Response)
    func presentNextPage(response: NowPlayingMovies.FetchNextPage.Response)
    func presentFilterMovies(response: NowPlayingMovies.FilterMovies.Response)
    func presentRefreshMovies(response: NowPlayingMovies.RefreshMovies.Response)
}

class NowPlayingMoviesPresenter {
    weak var viewController: NowPlayingMoviesDisplayLogic?
}

extension NowPlayingMoviesPresenter: NowPlayingMoviesPresentationLogic {
    
    func presentNowPlayingMovies(response: NowPlayingMovies.FetchNowPlayingMovies.Response) {
        DispatchQueue.main.async {
            let movieItems = response.movies?.compactMap({ movie -> MovieItem in
                return MovieItem(title: movie.title)
            })
            let shouldHideErrorView = response.error == nil
            let errorDescription = response.error?.localizedDescription
            let viewModel = NowPlayingMovies.FetchNowPlayingMovies.ViewModel(movieItems: movieItems, shouldHideErrorView: shouldHideErrorView, errorDescription: errorDescription)
            self.viewController?.displayNowPlayingMovies(viewModel: viewModel)
        }
    }
    
    func presentNextPage(response: NowPlayingMovies.FetchNextPage.Response) {
        DispatchQueue.main.async {
            let movieItems = response.movies?.compactMap({ movie -> MovieItem in
                return MovieItem(title: movie.title)
            })
            let shouldPresentErrorAlert = response.error != nil
            let errorAlertMessage = response.error?.localizedDescription
            let errorAlertCancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel)
            let viewModel = NowPlayingMovies.FetchNextPage.ViewModel(movieItems: movieItems,
                                                                     shouldPresentErrorAlert: shouldPresentErrorAlert,
                                                                     errorAlertTitle: nil,
                                                                     errorAlertMessage: errorAlertMessage,
                                                                     errorAlertStyle: .alert,
                                                                     errorAlertCancelAction: errorAlertCancelAction)
            self.viewController?.displayNextPage(viewModel: viewModel)
        }
    }
    
    func presentFilterMovies(response: NowPlayingMovies.FilterMovies.Response) {
        let movieItems = response.movies?.compactMap({ movie -> MovieItem in
            return MovieItem(title: movie.title)
        })
        let viewModel = NowPlayingMovies.FilterMovies.ViewModel(movieItems: movieItems)
        viewController?.displayFilterMovies(viewModel: viewModel)
    }
    
    func presentRefreshMovies(response: NowPlayingMovies.RefreshMovies.Response) {
        DispatchQueue.main.async {
            let movieItems = response.movies?.compactMap({ movie -> MovieItem in
                return MovieItem(title: movie.title)
            })
            let shouldPresentErrorAlert = response.error != nil
            let errorAlertMessage = response.error?.localizedDescription
            let errorAlertCancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel)
            let viewModel = NowPlayingMovies.RefreshMovies.ViewModel(movieItems: movieItems,
                                                                     shouldPresentErrorAlert: shouldPresentErrorAlert,
                                                                     errorAlertTitle: nil,
                                                                     errorAlertMessage: errorAlertMessage,
                                                                     errorAlertStyle: .alert,
                                                                     errorAlertCancelAction: errorAlertCancelAction)
            self.viewController?.displayRefreshMovies(viewModel: viewModel)
        }
    }
}
