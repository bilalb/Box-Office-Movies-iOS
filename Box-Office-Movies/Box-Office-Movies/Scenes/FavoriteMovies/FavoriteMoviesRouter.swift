//
//  FavoriteMoviesRouter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 27.05.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol FavoriteMoviesDataPassing {
    var dataStore: FavoriteMoviesDataStore? { get }
}

class FavoriteMoviesRouter: NSObject, FavoriteMoviesDataPassing {
    weak var viewController: FavoriteMoviesViewController?
    var dataStore: FavoriteMoviesDataStore?
}

// MARK: - Private Functions
private extension FavoriteMoviesRouter {
//    func navigateToSomewhere(source: FavoriteMoviesViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }
//
//    func passDataToSomewhere(source: FavoriteMoviesDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}

@objc protocol FavoriteMoviesRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

extension FavoriteMoviesRouter: FavoriteMoviesRoutingLogic {
//    func routeToSomewhere(segue: UIStoryboardSegue?) {
//        if let segue = segue,
//            let destinationVC = segue.destination as? SomewhereViewController,
//            var destinationDS = destinationVC.router?.dataStore {
//
//            passDataToSomewhere(source: dataStore, destination: &destinationDS)
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as? SomewhereViewController,
//                var destinationDS = destinationVC.router?.dataStore {
//                passDataToSomewhere(source: dataStore, destination: &destinationDS)
//                navigateToSomewhere(source: viewController, destination: destinationVC)
//            }
//        }
//    }
}
