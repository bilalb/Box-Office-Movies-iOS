//
//  NowPlayingMoviesRouter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol NowPlayingMoviesDataPassing {
    var dataStore: NowPlayingMoviesDataStore? { get }
}

class NowPlayingMoviesRouter: NSObject, NowPlayingMoviesDataPassing {
    weak var viewController: NowPlayingMoviesViewController?
    var dataStore: NowPlayingMoviesDataStore?
}

// MARK: - Private Functions
private extension NowPlayingMoviesRouter {
//    func navigateToSomewhere(source: NowPlayingMoviesViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }
//
//    func passDataToSomewhere(source: NowPlayingMoviesDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}

@objc protocol NowPlayingMoviesRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

extension NowPlayingMoviesRouter: NowPlayingMoviesRoutingLogic {
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
