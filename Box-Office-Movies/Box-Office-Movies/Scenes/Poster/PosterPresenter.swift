//
//  PosterPresenter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol PosterPresentationLogic {
    func presentSmallSizePosterImage(response: Poster.LoadSmallSizePosterImage.Response)
    func presentPosterImage(response: Poster.FetchPosterImage.Response)
}

final class PosterPresenter {
    weak var viewController: PosterDisplayLogic?
}

extension PosterPresenter: PosterPresentationLogic {
    
    func presentSmallSizePosterImage(response: Poster.LoadSmallSizePosterImage.Response) {
        let smallSizePosterImage = UIImage(data: response.smallSizePosterData ?? Data())
        let viewModel = Poster.LoadSmallSizePosterImage.ViewModel(smallSizePosterImage: smallSizePosterImage)
        viewController?.displaySmallSizePosterImage(viewModel: viewModel)
    }
    
    func presentPosterImage(response: Poster.FetchPosterImage.Response) {
        DispatchQueue.main.async {
            let posterImage = UIImage(data: response.posterData ?? Data())
            let viewModel = Poster.FetchPosterImage.ViewModel(posterImage: posterImage)
            self.viewController?.displayPosterImage(viewModel: viewModel)
        }
    }
}
