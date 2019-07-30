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

@objc protocol MovieDetailsRoutingLogic {
    func routeToPosterImage(segue: UIStoryboardSegue?)
}

extension MovieDetailsRouter: MovieDetailsRoutingLogic {
    
    func routeToPosterImage(segue: UIStoryboardSegue?) {
        if let segue = segue,
            let destinationVC = segue.destination as? ImageViewController,
            let dataStore = dataStore {
            passDataToPosterImage(source: dataStore, destination: destinationVC)
        }
    }
}

// MARK: - Private Functions
private extension MovieDetailsRouter {
    
    func navigateToPosterImage(source: MovieDetailsViewController, destination: ImageViewController) {
        source.present(destination, animated: true)
    }
    
    func passDataToPosterImage(source: MovieDetailsDataStore, destination: ImageViewController) {
        guard let posterData = source.posterData else {
            return
        }
        destination.image = UIImage(data: posterData)
    }
}
