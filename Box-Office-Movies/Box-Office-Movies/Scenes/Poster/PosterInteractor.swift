//
//  PosterInteractor.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import UIKit

protocol PosterDataStore {
    var imageSecureBaseURLPath: String? { get set }
    var posterPath: String? { get set }
}

protocol PosterBusinessLogic {
    func fetchPosterImage(request: Poster.FetchPosterImage.Request)
}

class PosterInteractor: PosterDataStore {
    
    // MARK: Instance Properties
    var presenter: PosterPresentationLogic?
    var imageSecureBaseURLPath: String?
    var posterPath: String?
}

extension PosterInteractor: PosterBusinessLogic {
    
    func fetchPosterImage(request: Poster.FetchPosterImage.Request) {
        guard
            let imageSecureBaseURLPath = imageSecureBaseURLPath,
            let posterPath = posterPath
        else {
            return
        }
        ManagerProvider.shared.movieManager.posterData(imageSecureBaseURL: imageSecureBaseURLPath, posterSize: Constants.Fallback.largePosterImageSize, posterPath: posterPath) { [weak self] (posterData, error) in
            let response = Poster.FetchPosterImage.Response(posterData: posterData)
            self?.presenter?.presentPosterImage(response: response)
        }
    }
}
