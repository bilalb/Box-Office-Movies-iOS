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

class MovieDetailsRouter: NSObject, MovieDetailsDataPassing {
    weak var viewController: MovieDetailsViewController?
    var dataStore: MovieDetailsDataStore?
}

// MARK: - Private Functions
private extension MovieDetailsRouter {
//    func navigateToSomewhere(source: MovieDetailsViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }
//
//    func passDataToSomewhere(source: MovieDetailsDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}

@objc protocol MovieDetailsRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

extension MovieDetailsRouter: MovieDetailsRoutingLogic {
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
