//
//  Poster+SceneSetup.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

extension PosterViewController {
    func sceneSetup() {
        let viewController = self
        let interactor = PosterInteractor()
        let presenter = PosterPresenter()
        let router = PosterRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
