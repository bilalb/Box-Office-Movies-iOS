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
    func loadPosterImage(request: Poster.LoadPosterImage.Request)
}

class PosterInteractor: PosterDataStore {
    
    // MARK: Instance Properties
    var presenter: PosterPresentationLogic?
    var imageSecureBaseURLPath: String?
    var posterPath: String?
}

extension PosterInteractor: PosterBusinessLogic {
    
    func loadPosterImage(request: Poster.LoadPosterImage.Request) {
        guard
            let imageSecureBaseURLPath = imageSecureBaseURLPath,
            let posterPath = posterPath
        else {
            return
        }
        ManagerProvider.shared.movieManager.poster(imageSecureBaseURL: imageSecureBaseURLPath, posterSize: Constants.Fallback.posterImageSize, posterPath: posterPath) { [weak self] (posterData, error) in
            let response = Poster.LoadPosterImage.Response(posterData: posterData/*, error: error*/)
            self?.presenter?.presentPosterImage(response: response)
        }
    }
}
