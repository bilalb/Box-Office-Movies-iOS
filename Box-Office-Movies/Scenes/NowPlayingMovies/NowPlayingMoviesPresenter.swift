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
    func presentFilterMovies(response: NowPlayingMovies.FilterMovies.Response)
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
            let viewModel = NowPlayingMovies.FetchNowPlayingMovies.ViewModel(movieItems: movieItems)
            self.viewController?.displayNowPlayingMovies(viewModel: viewModel)
        }
    }
    
    func presentFilterMovies(response: NowPlayingMovies.FilterMovies.Response) {
        let movieItems = response.movies?.compactMap({ movie -> MovieItem in
            return MovieItem(title: movie.title)
        })
        let viewModel = NowPlayingMovies.FilterMovies.ViewModel(movieItems: movieItems)
        viewController?.displayFilterMovies(viewModel: viewModel)
    }
}
