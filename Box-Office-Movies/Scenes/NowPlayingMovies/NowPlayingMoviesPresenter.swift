//
//  NowPlayingMoviesPresenter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All right reserved.
//

import UIKit

protocol NowPlayingMoviesPresentationLogic {
    func presentNowPlayingMovies(response: NowPlayingMovies.FetchNowPlayingMovies.Response)
}

class NowPlayingMoviesPresenter {
    weak var viewController: NowPlayingMoviesDisplayLogic?
}

extension NowPlayingMoviesPresenter: NowPlayingMoviesPresentationLogic {
    
    func presentNowPlayingMovies(response: NowPlayingMovies.FetchNowPlayingMovies.Response) {
        DispatchQueue.main.async {
            var movieItems = [NowPlayingMovies.FetchNowPlayingMovies.ViewModel.MovieItem]()
            response.paginatedMovieLists?.forEach({ (paginatedMovieList) in
                let currentMovieItems = paginatedMovieList.movies.compactMap({ (movie) -> NowPlayingMovies.FetchNowPlayingMovies.ViewModel.MovieItem? in
                    return NowPlayingMovies.FetchNowPlayingMovies.ViewModel.MovieItem(title: movie.title)
                })
                movieItems.append(contentsOf: currentMovieItems)
            })
            let viewModel = NowPlayingMovies.FetchNowPlayingMovies.ViewModel(movieItems: movieItems)
            self.viewController?.displayNowPlayingMovies(viewModel: viewModel)
        }
    }
}
