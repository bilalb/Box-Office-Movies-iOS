//
//  MovieDetailsPresenter.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import UIKit

protocol MovieDetailsPresentationLogic {
    func presentMovieDetails(response: MovieDetailsScene.FetchMovieDetails.Response)
    func presentMovieReviews(response: MovieDetailsScene.LoadMovieReviews.Response)
    func presentReviewMovie(response: MovieDetailsScene.ReviewMovie.Response)
}

class MovieDetailsPresenter {
    weak var viewController: MovieDetailsDisplayLogic?
}

extension MovieDetailsPresenter: MovieDetailsPresentationLogic {
    
    func presentMovieDetails(response: MovieDetailsScene.FetchMovieDetails.Response) {
        DispatchQueue.main.async {
            
            func displayMovieDetails(detailItems: [DetailItem]?, shouldHideErrorView: Bool, errorDescription: String?) {
                let viewModel = MovieDetailsScene.FetchMovieDetails.ViewModel(detailItems: detailItems, shouldHideErrorView: shouldHideErrorView, errorDescription: errorDescription)
                self.viewController?.displayMovieDetails(viewModel: viewModel)
            }
            
            guard response.error == nil else {
                let errorDescription = response.error?.localizedDescription
                displayMovieDetails(detailItems: nil, shouldHideErrorView: false, errorDescription: errorDescription)
                return
            }
            
            guard let movieDetails = response.movieDetails else {
                displayMovieDetails(detailItems: nil, shouldHideErrorView: false, errorDescription: nil)
                return
            }
            
            let titleItem = DetailItem.title(title: movieDetails.title)
            let additionalInformationDetailItem = self.additionalInformationItem(for: movieDetails, posterImage: response.posterImage)
            let reviewMovieItem = DetailItem.reviewMovie(review: NSLocalizedString("review", comment: "review"))
            var detailItems = [titleItem, additionalInformationDetailItem, reviewMovieItem]
            
            if let synopsisDetailItem = self.synopsisItem(for: movieDetails.synopsis) {
                detailItems.append(synopsisDetailItem)
            }
            if let castingDetailItem = self.castingItem(for: response.casting) {
                detailItems.append(castingDetailItem)
            }
            if let similarMoviesDetailItem = self.similarMoviesItem(for: response.paginatedSimilarMovieLists) {
                detailItems.append(similarMoviesDetailItem)
            }
            
            displayMovieDetails(detailItems: detailItems, shouldHideErrorView: true, errorDescription: nil)
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
}

extension MovieDetailsPresenter {
    
    func additionalInformationItem(for movieDetails: MovieDetails, posterImage: UIImage?) -> DetailItem {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.darkText,
                                                         .font: UIFont.boldSystemFont(ofSize: 15)]
        
        var releaseDateAttributedString: NSAttributedString? {
            let iso8601DateFormatter = ISO8601DateFormatter()
            iso8601DateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
            if let releaseDate = iso8601DateFormatter.date(from: movieDetails.releaseDate) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.locale = Locale.current
                let releaseDateString = dateFormatter.string(from: releaseDate)
                
                let releaseDateText = "\(NSLocalizedString("releaseDate", comment: "releaseDate"))\n\(releaseDateString)"
                let releaseDateAttributedString = NSMutableAttributedString(string: releaseDateText)
                let range = NSRange(location: 0, length: NSLocalizedString("releaseDate", comment: "releaseDate").count)
                releaseDateAttributedString.addAttributes(attributes, range: range)
                
                return releaseDateAttributedString
            } else {
                return nil
            }
        }
        
        var voteAverageAttributedString: NSAttributedString? {
            let voteAverage = "\(NSLocalizedString("averageVote", comment: "averageVote"))\n\(movieDetails.formattedVoteAverage)"
            let voteAverageAttributedString = NSMutableAttributedString(string: voteAverage)
            let range = NSRange(location: 0, length: NSLocalizedString("averageVote", comment: "averageVote").count)
            voteAverageAttributedString.addAttributes(attributes, range: range)
            
            return voteAverageAttributedString
        }
        
        return DetailItem.additionalInformation(posterImage: posterImage, releaseDateAttributedText: releaseDateAttributedString, voteAverageAttributedText: voteAverageAttributedString)
    }
    
    func synopsisItem(for synopsis: String?) -> DetailItem? {
        guard let synopsis = synopsis, !synopsis.isEmpty else {
            return nil
        }
        return DetailItem.synopsis(synopsis: synopsis)
    }
    
    func castingItem(for casting: Casting?) -> DetailItem? {
        var actors = ""
        casting?.actors.forEach({ (actor) in
            actors.append(withSeparator: ", ", other: actor.name)
        })
        guard !actors.isEmpty else {
            return nil
        }
        return DetailItem.casting(actors: actors)
    }
    
    func similarMoviesItem(for paginatedSimilarMovieLists: [PaginatedMovieList]?) -> DetailItem? {
        var similarMovies = ""
        paginatedSimilarMovieLists?.forEach({ (paginatedSimilarMovieList) in
            paginatedSimilarMovieList.movies.forEach({ (movie) in
                similarMovies.append(withSeparator: ", ", other: movie.title)
            })
        })
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
