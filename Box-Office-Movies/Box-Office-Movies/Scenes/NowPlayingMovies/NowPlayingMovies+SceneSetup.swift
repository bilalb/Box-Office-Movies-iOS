//
//  NowPlayingMovies+SceneSetup.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

extension NowPlayingMoviesViewController {
    func sceneSetup() {
        let viewController = self
        let interactor = NowPlayingMoviesInteractor()
        let presenter = NowPlayingMoviesPresenter()
        let router = NowPlayingMoviesRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
