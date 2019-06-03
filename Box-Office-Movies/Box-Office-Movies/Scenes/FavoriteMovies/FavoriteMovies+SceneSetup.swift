//
//  FavoriteMovies+SceneSetup.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 27.05.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

extension FavoriteMoviesViewController {
    func sceneSetup() {
        let viewController = self
        let interactor = FavoriteMoviesInteractor()
        let presenter = FavoriteMoviesPresenter()
        let router = FavoriteMoviesRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
