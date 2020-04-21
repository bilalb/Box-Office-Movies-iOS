//
//  MovieDetailsRouter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol MovieDetailsDataPassing {
    var dataStore: MovieDetailsDataStore? { get }
}

final class MovieDetailsRouter: NSObject, MovieDetailsDataPassing {
    weak var viewController: MovieDetailsViewController?
    var dataStore: MovieDetailsDataStore?
}

@objc protocol MovieDetailsRoutingLogic {
    func routeToPoster()
}

extension MovieDetailsRouter: MovieDetailsRoutingLogic {
    
    func routeToPoster() {
        let storyboard = UIStoryboard(name: Constants.StoryboardName.poster, bundle: Bundle.main)
        if let dataStore = dataStore,
            let viewController = viewController,
            let destinationVC = storyboard.instantiateViewController(withIdentifier: PosterViewController.identifier) as? PosterViewController,
            var destinationDS = destinationVC.router?.dataStore {
            passDataToPoster(source: dataStore, destination: &destinationDS)
            navigateToPoster(source: viewController, destination: destinationVC)
        }
    }
}

// MARK: - Private Functions
private extension MovieDetailsRouter {
    
    func navigateToPoster(source: MovieDetailsViewController, destination: PosterViewController) {
        let navigationController = UINavigationController(rootViewController: destination)
        source.present(navigationController, animated: true)
    }
    
    func passDataToPoster(source: MovieDetailsDataStore, destination: inout PosterDataStore) {
        destination.smallSizePosterData = source.posterData
        destination.imageSecureBaseURLPath = source.imageSecureBaseURLPath
        destination.posterPath = source.posterPath
    }
}
