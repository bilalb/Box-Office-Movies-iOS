//
//  PosterPresenter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol PosterPresentationLogic {
    func presentPosterImage(response: Poster.FetchPosterImage.Response)
}

class PosterPresenter {
    weak var viewController: PosterDisplayLogic?
}

extension PosterPresenter: PosterPresentationLogic {
    
    func presentPosterImage(response: Poster.FetchPosterImage.Response) {
        DispatchQueue.main.async {
            let posterImage = UIImage(data: response.posterData ?? Data())
            let viewModel = Poster.FetchPosterImage.ViewModel(posterImage: posterImage)
            self.viewController?.displayPosterImage(viewModel: viewModel)
        }
    }
}
