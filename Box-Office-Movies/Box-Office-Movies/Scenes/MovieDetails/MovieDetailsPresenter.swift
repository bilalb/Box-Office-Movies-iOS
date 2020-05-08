//
//  MovieDetailsPresenter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import UIKit

protocol MovieDetailsPresentationLogic {
    func presentMovieDetails(response: MovieDetailsScene.FetchMovieDetails.Response)
    func presentMovieReviews(response: MovieDetailsScene.LoadMovieReviews.Response)
    func presentReviewMovie(response: MovieDetailsScene.ReviewMovie.Response)
    func presentFavoriteToggle(response: MovieDetailsScene.LoadFavoriteToggle.Response)
    func presentTableViewBackgroundView(response: MovieDetailsScene.LoadTableViewBackgroundView.Response)
}

final class MovieDetailsPresenter {
    weak var viewController: MovieDetailsDisplayLogic?
}

extension MovieDetailsPresenter: MovieDetailsPresentationLogic {
    
    func presentMovieDetails(response: MovieDetailsScene.FetchMovieDetails.Response) {
        DispatchQueue.main.async {
            
            func displayMovieDetails(detailItems: [DetailItem]?) {
                let shouldShowNetworkActivityIndicator = response.remainingRequestCount > 0
                let viewModel = MovieDetailsScene.FetchMovieDetails.ViewModel(detailItems: detailItems, shouldShowNetworkActivityIndicator: shouldShowNetworkActivityIndicator)
                self.viewController?.displayMovieDetails(viewModel: viewModel)
            }
            
            guard response.error == nil, let movieDetails = response.movieDetails else {
                displayMovieDetails(detailItems: nil)
                return
            }
            
            let titleItem = DetailItem.title(title: movieDetails.title)
            let additionalInformationDetailItem = self.additionalInformationItem(for: movieDetails, posterData: response.posterData)
            var detailItems = [titleItem, additionalInformationDetailItem]

            if response.isReviewEnabled {
                let reviewMovieItem = DetailItem.reviewMovie(review: NSLocalizedString("review", comment: "review"))
                detailItems.append(reviewMovieItem)
            }
            
            if let trailerDetailItem = self.trailerItem(for: response.trailer) {
                detailItems.append(trailerDetailItem)
            }
            if let synopsisDetailItem = self.synopsisItem(for: movieDetails.synopsis) {
                detailItems.append(synopsisDetailItem)
            }
            if let castingDetailItem = self.castingItem(for: response.casting) {
                detailItems.append(castingDetailItem)
            }
            if let similarMoviesDetailItem = self.similarMoviesItem(for: response.paginatedSimilarMovieLists) {
                detailItems.append(similarMoviesDetailItem)
            }
            
            displayMovieDetails(detailItems: detailItems)
        }
    }
    
    func presentMovieReviews(response: MovieDetailsScene.LoadMovieReviews.Response) {
        var actions = response.movieReviews.compactMap { (movieReview) -> (UIAlertAction, MovieReview?) in
            let alertAction = UIAlertAction(title: movieReview.description, style: .default, handler: nil)
            return (alertAction, movieReview)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel, handler: nil)
        actions.append((cancelAction, nil))
        let viewModel = MovieDetailsScene.LoadMovieReviews.ViewModel(alertControllerTitle: NSLocalizedString("reviewTheMovie", comment: "reviewTheMovie"),
                                                                     alertControllerMessage: nil,
                                                                     alertControllerPreferredStyle: .actionSheet,
                                                                     actions: actions)
        viewController?.displayMovieReviews(viewModel: viewModel)
    }
    
    func presentReviewMovie(response: MovieDetailsScene.ReviewMovie.Response) {
        let reviewMovieItem = DetailItem.reviewMovie(review: response.movieReview.description)
        let viewModel = MovieDetailsScene.ReviewMovie.ViewModel(reviewMovieItem: reviewMovieItem)
        viewController?.displayReviewMovie(viewModel: viewModel)
    }
    
    func presentFavoriteToggle(response: MovieDetailsScene.LoadFavoriteToggle.Response) {
        let toggleFavoriteBarButtonItemTitle = response.isFavorite == true ? "★" : "☆"
        let viewModel = MovieDetailsScene.LoadFavoriteToggle.ViewModel(toggleFavoriteBarButtonItemTitle: toggleFavoriteBarButtonItemTitle)
        viewController?.displayFavoriteToggle(viewModel: viewModel)
    }

    func presentTableViewBackgroundView(response: MovieDetailsScene.LoadTableViewBackgroundView.Response) {
        let backgroundView: UIView? = {
            guard response.movieDetails == nil &&
                response.casting == nil &&
                response.paginatedSimilarMovieLists?.isEmpty == true &&
                response.posterData == nil &&
                response.trailer == nil,
                let emptyBackgroundView = EmptyBackgroundView.fromNib(named: Constants.NibName.emptyBackgroundView) as? EmptyBackgroundView
            else { return nil }

            emptyBackgroundView.message = NSLocalizedString("genericErrorMessage", comment: "genericErrorMessage")
            emptyBackgroundView.shouldDisplayRetryButton = true

            if let viewController = viewController as? MovieDetailsViewController {
                emptyBackgroundView.retryButtonAction = {
                    viewController.retryButtonPressed()
                }
            }

            return emptyBackgroundView
        }()
        let viewModel = MovieDetailsScene.LoadTableViewBackgroundView.ViewModel(backgroundView: backgroundView)
        viewController?.displayTableViewBackgroundView(viewModel: viewModel)
    }
}

extension MovieDetailsPresenter {
    
    func additionalInformationItem(for movieDetails: MovieDetails, posterData: Data?) -> DetailItem {
        var posterImage: UIImage? {
            if let posterData = posterData {
                return UIImage(data: posterData)
            }
            return nil
        }
        
        var releaseDate: String? {
            let iso8601DateFormatter = ISO8601DateFormatter()
            iso8601DateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
            if let releaseDate = iso8601DateFormatter.date(from: movieDetails.releaseDate) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.locale = .current
                let releaseDateString = dateFormatter.string(from: releaseDate)
                return releaseDateString
            } else {
                return nil
            }
        }
        
        var voteAverage: String? {
            let voteAverage = "\(movieDetails.formattedVoteAverage)"
            return voteAverage
        }
        
        return DetailItem.additionalInformation(posterImage: posterImage, releaseDate: releaseDate, voteAverage: voteAverage)
    }
    
    func trailerItem(for trailer: Video?) -> DetailItem? {
        guard
            let trailer = trailer,
            !trailer.key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            trailer.site == .youTube
        else {
            return nil
        }
        let trailerURLString = String(format: Constants.VideoURL.youTube, trailer.key)
        guard let url = URL(string: trailerURLString) else {
            return nil
        }
        let urlRequest = URLRequest(url: url)
        return DetailItem.trailer(urlRequest: urlRequest)
    }
    
    func synopsisItem(for synopsis: String?) -> DetailItem? {
        guard let synopsis = synopsis, !synopsis.isEmpty else {
            return nil
        }
        return DetailItem.synopsis(synopsis: synopsis)
    }
    
    func castingItem(for casting: Casting?) -> DetailItem? {
        guard let actors = casting?.actors.compactMap({$0.name}).joined(separator: ", "),
            !actors.isEmpty
        else {
            return nil
        }
        return DetailItem.casting(actors: actors)
    }
    
    func similarMoviesItem(for paginatedSimilarMovieLists: [PaginatedMovieList]?) -> DetailItem? {
        guard let joinedSimilarMovies = paginatedSimilarMovieLists?.compactMap({ $0.movies.compactMap({ $0.title }) }).joined() else { return nil }
        let similarMovies = Array(joinedSimilarMovies).joined(separator: ", ")
        
        guard !similarMovies.isEmpty else {
            return nil
        }
        return DetailItem.similarMovies(similarMovies: similarMovies)
    }
}

extension MovieDetails {
    
    /// Vote average represented with stars
    var formattedVoteAverage: String {
        let numberOfStars = 5
        let highestPossibleValueOfVoteAverage = 10
        let numberOfFullStars: Int = Int(voteAverage) * numberOfStars / highestPossibleValueOfVoteAverage
        let numberOfEmptyStars = numberOfStars - numberOfFullStars
        var stars = ""
        for _ in 0 ..< numberOfFullStars {
            stars.append("★")
        }
        for _ in 0 ..< numberOfEmptyStars {
            stars.append("☆")
        }
        return stars
    }
}
