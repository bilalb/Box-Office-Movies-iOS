//
//  PosterRouter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol PosterDataPassing {
    var dataStore: PosterDataStore? { get }
}

class PosterRouter: NSObject, PosterDataPassing {
    weak var viewController: PosterViewController?
    var dataStore: PosterDataStore?
}

// MARK: - Private Functions
private extension PosterRouter {
//    func navigateToSomewhere(source: PosterViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }
//
//    func passDataToSomewhere(source: PosterDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}

@objc protocol PosterRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

extension PosterRouter: PosterRoutingLogic {
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
