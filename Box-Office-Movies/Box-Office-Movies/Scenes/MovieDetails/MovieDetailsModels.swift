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
            let posterData: Data?
            let trailer: Video?
            let error: Error?
            let remainingRequestCount: Int
            let isReviewEnabled: Bool
        }
        
        struct ViewModel {
            let detailItems: [DetailItem]?
            let shouldHideErrorView: Bool
            let errorDescription: String?
            let shouldShowNetworkActivityIndicator: Bool
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
    
    enum LoadFavoriteToggle {
        
        struct Request { }
        
        struct Response {
            let isFavorite: Bool?
        }
        
        struct ViewModel {
            let toggleFavoriteBarButtonItemTitle: String
        }
    }
    
    enum ToggleFavorite {
        
        struct Request { }
        
        struct Response {
            let isMovieAddedToFavorite: Bool
        }
        
        struct ViewModel {
            let toggleFavoriteBarButtonItemTitle: String
        }
    }
}

enum DetailItem {
    
    case title(title: String)
    case additionalInformation(posterImage: UIImage?, releaseDate: String?, voteAverage: String?)
    case reviewMovie(review: String)
    case trailer(urlRequest: URLRequest)
    case synopsis(synopsis: String)
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
        case .trailer:
            return TrailerTableViewCell.identifier
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
