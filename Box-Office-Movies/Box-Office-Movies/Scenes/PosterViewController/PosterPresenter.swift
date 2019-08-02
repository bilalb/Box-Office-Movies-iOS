//
//  PosterPresenter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol PosterPresentationLogic {
    func presentPosterImage(response: Poster.LoadPosterImage.Response)
}

class PosterPresenter {
    weak var viewController: PosterDisplayLogic?
}

extension PosterPresenter: PosterPresentationLogic {
    
    func presentPosterImage(response: Poster.LoadPosterImage.Response) {
        DispatchQueue.main.async {
            let posterImage = UIImage(data: response.posterData ?? Data())
            let viewModel = Poster.LoadPosterImage.ViewModel(posterImage: posterImage)
            self.viewController?.displayPosterImage(viewModel: viewModel)
        }
    }
}
