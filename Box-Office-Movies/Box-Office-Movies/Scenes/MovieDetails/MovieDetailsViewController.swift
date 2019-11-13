//
//  MovieDetailsViewController.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol MovieDetailsDisplayLogic: class {
    func displayMovieDetails(viewModel: MovieDetailsScene.FetchMovieDetails.ViewModel)
    func displayMovieReviews(viewModel: MovieDetailsScene.LoadMovieReviews.ViewModel)
    func displayReviewMovie(viewModel: MovieDetailsScene.ReviewMovie.ViewModel)
    func displayToggleFavorite(viewModel: MovieDetailsScene.ToggleFavorite.ViewModel)
    func displayFavoriteToggle(viewModel: MovieDetailsScene.LoadFavoriteToggle.ViewModel)
}

class MovieDetailsViewController: UIViewController {
    // MARK: Instance Properties
    var interactor: MovieDetailsBusinessLogic?
    var router: (NSObjectProtocol & MovieDetailsRoutingLogic & MovieDetailsDataPassing)?
    
    var detailItems = [DetailItem]() {
        didSet {
            detailItemsTableView.reloadData()
        }
    }
    
    @IBOutlet weak var toggleFavoriteBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var detailItemsTableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorStackView: ErrorStackView!

    // MARK: Object Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        sceneSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sceneSetup()
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // When the split view controller is not collapsed this scene is displayed.
        // If no movie is selected (for example when there is a network error and the movie list is empty) this scene is empty and does not display any data.
        // Then we stop the animation of the activity indicator view.
        guard router?.dataStore?.movieIdentifier != nil else {
            activityIndicatorView.stopAnimating()
            return
        }
        
        fetchMovieDetails()
        loadFavoriteToggle()
    }
}

// MARK: - Private Functions
private extension MovieDetailsViewController {
    
    func fetchMovieDetails() {
        if #available(iOS 13.0, *) { } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        activityIndicatorView.startAnimating()

        let request = MovieDetailsScene.FetchMovieDetails.Request()
        interactor?.fetchMovieDetails(request: request)
    }
    
    func loadMovieReviews() {
        let request = MovieDetailsScene.LoadMovieReviews.Request()
        interactor?.loadMovieReviews(request: request)
    }
    
    func reviewMovie(with movieReview: MovieReview) {
        let request = MovieDetailsScene.ReviewMovie.Request(movieReview: movieReview)
        interactor?.reviewMovie(request: request)
    }
    
    @IBAction func errorActionButtonPressed() {
        fetchMovieDetails()
        errorStackView.isHidden = true
    }
    
    func loadFavoriteToggle() {
        let request = MovieDetailsScene.LoadFavoriteToggle.Request()
        interactor?.loadFavoriteToggle(request: request)
    }
    
    @IBAction func toggleFavoriteBarButtonItemPressed() {
        toggleFavorite()
    }
    
    func toggleFavorite() {
        let request = MovieDetailsScene.ToggleFavorite.Request()
        interactor?.toggleFavorite(request: request)
    }

    func refreshFavoriteMovies() {
        var nowPlayingMoviesViewController: NowPlayingMoviesViewController?
        splitViewController?.viewControllers.forEach({ viewController in
            if let navigationController = viewController as? UINavigationController,
                let matchingViewController = navigationController.viewControllers.first(where: { $0 is NowPlayingMoviesViewController }) as? NowPlayingMoviesViewController {
                nowPlayingMoviesViewController = matchingViewController
            }
        })
        nowPlayingMoviesViewController?.refreshFavoriteMovies()
    }
    
    @IBAction func posterImageViewTapGestureRecognizerPressed() {
        router?.routeToPoster()
    }
}

// MARK: - Display Logic
extension MovieDetailsViewController: MovieDetailsDisplayLogic {
    
    func displayMovieDetails(viewModel: MovieDetailsScene.FetchMovieDetails.ViewModel) {
        detailItems = viewModel.detailItems ?? []

        if #available(iOS 13.0, *) { } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = viewModel.shouldShowNetworkActivityIndicator
        }
        activityIndicatorView.stopAnimating()
        
        errorStackView.isHidden = viewModel.shouldHideErrorView
        errorStackView.errorDescription = viewModel.errorDescription
    }
    
    func displayMovieReviews(viewModel: MovieDetailsScene.LoadMovieReviews.ViewModel) {
        let alertController = UIAlertController(title: viewModel.alertControllerTitle, message: viewModel.alertControllerMessage, preferredStyle: viewModel.alertControllerPreferredStyle)
        viewModel.actions.forEach({ (alertAction, movieReview) in
            let action = UIAlertAction(title: alertAction.title, style: alertAction.style, handler: { [weak self] _ in
                if let movieReview = movieReview {
                    self?.reviewMovie(with: movieReview)
                }
            })
            alertController.addAction(action)
        })
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
        present(alertController, animated: true)
    }
    
    func displayReviewMovie(viewModel: MovieDetailsScene.ReviewMovie.ViewModel) {
        let indexOfReviewMovieItem = detailItems.firstIndex { detailItem -> Bool in
            if case .reviewMovie = detailItem {
                return true
            } else {
                return false
            }
        }
        if let indexOfReviewMovieItem = indexOfReviewMovieItem {
            detailItems[indexOfReviewMovieItem] = viewModel.reviewMovieItem
        }
    }
    
    func displayToggleFavorite(viewModel: MovieDetailsScene.ToggleFavorite.ViewModel) {
        toggleFavoriteBarButtonItem.title = viewModel.toggleFavoriteBarButtonItemTitle
        refreshFavoriteMovies()
    }
    
    func displayFavoriteToggle(viewModel: MovieDetailsScene.LoadFavoriteToggle.ViewModel) {
        toggleFavoriteBarButtonItem.title = viewModel.toggleFavoriteBarButtonItemTitle
    }
}

// MARK: - UITableViewDataSource
extension MovieDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard detailItems.indices.contains(indexPath.row) else {
            return UITableViewCell()
        }
        let detailItem = detailItems[indexPath.row]
        let cellIdentifier = detailItem.cellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        switch detailItem {
        case .title(let title):
            cell.textLabel?.text = title
        case .additionalInformation(let posterImage, let releaseDate, let voteAverage):
            if let cell = cell as? AdditionalInformationTableViewCell {
                cell.posterImageView?.image = posterImage
                cell.releaseDateLabel?.text = releaseDate
                cell.voteAverageLabel?.text = voteAverage
            }
        case .reviewMovie(let review):
            cell.detailTextLabel?.text = review
        case .trailer(let urlRequest):
            if let cell = cell as? TrailerTableViewCell {
                cell.webView.load(urlRequest)
            }
        case .synopsis(let synopsis):
            cell.detailTextLabel?.text = synopsis
        case .casting(let actors):
            cell.detailTextLabel?.text = actors
        case .similarMovies(let similarMovies):
            cell.detailTextLabel?.text = similarMovies
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MovieDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard detailItems.indices.contains(indexPath.row) else {
            return
        }
        let detailItem = detailItems[indexPath.row]
        
        switch detailItem {
        case .reviewMovie:
            loadMovieReviews()
        default:
            break
        }
    }
}
