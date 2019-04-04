//
//  MovieDetailsModels.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import UIKit

enum MovieDetailsScene {
    
    enum FetchMovieDetails {
        
        struct Request { }
        
        struct Response {
            let movieDetails: MovieDetails?
            let casting: Casting?
            let paginatedSimilarMovieLists: [PaginatedMovieList]?
            let posterImage: UIImage?
            let error: Error?
        }
        
        struct ViewModel {
            let detailItems: [DetailItem]?
            let shouldHideErrorView: Bool
            let errorDescription: String?
        }
    }
    
    enum LoadMovieReviews {
        
        struct Request { }
        
        struct Response {
            let movieReviews: [MovieReview]
        }
        
        struct ViewModel {
            let alertControllerTitle: String?
            let alertControllerMessage: String?
            let alertControllerPreferredStyle: UIAlertController.Style
            let actions: [(alertAction: UIAlertAction, movieReview: MovieReview?)]
        }
    }
    
    enum ReviewMovie {
        
        struct Request {
            let movieReview: MovieReview
        }
        
        struct Response {
            let movieReview: MovieReview
        }
        
        struct ViewModel {
            let reviewMovieItem: DetailItem
        }
    }
}

enum DetailItem {
    
    case title(title: String)
    case additionalInformation(posterImage: UIImage?, releaseDateAttributedText: NSAttributedString?, voteAverageAttributedText: NSAttributedString?)
    case synopsis(synopsis: String)
    case reviewMovie(review: String)
    case casting(actors: String)
    case similarMovies(similarMovies: String)
    
    var cellIdentifier: String {
        switch self {
        case .title:
            return Constants.CellIdentifier.titleTableViewCell
        case .additionalInformation:
            return AdditionalInformationTableViewCell.identifier
        case .reviewMovie:
            return Constants.CellIdentifier.reviewMovieTableViewCell
        case .synopsis:
            return Constants.CellIdentifier.synopsisTableViewCell
        case .casting:
            return Constants.CellIdentifier.castingTableViewCell
        case .similarMovies:
            return Constants.CellIdentifier.similarMoviesTableViewCell
        }
    }
}

enum MovieReview: CaseIterable {
    
    case oneStar
    case twoStars
    case threeStars
    case fourStars
    case fiveStars
    
    var description: String {
        switch self {
        case .oneStar:
            return "★☆☆☆☆"
        case .twoStars:
            return "★★☆☆☆"
        case .threeStars:
            return "★★★☆☆"
        case .fourStars:
            return "★★★★☆"
        case .fiveStars:
            return "★★★★★"
        }
    }
}
