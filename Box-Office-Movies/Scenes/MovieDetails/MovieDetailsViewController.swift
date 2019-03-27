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
    func displayCasting(viewModel: MovieDetailsScene.FetchCasting.ViewModel)
    func displaySimilarMovies(viewModel: MovieDetailsScene.FetchSimilarMovies.ViewModel)
    func displayMovieReviews(viewModel: MovieDetailsScene.LoadMovieReviews.ViewModel)
    func displayReviewMovie(viewModel: MovieDetailsScene.ReviewMovie.ViewModel)
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
    
    @IBOutlet weak var detailItemsTableView: UITableView!
    
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
        fetchMovieDetails()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
}

// MARK: - Private Functions
private extension MovieDetailsViewController {
    
    func fetchMovieDetails() {
        let request = MovieDetailsScene.FetchMovieDetails.Request()
        interactor?.fetchMovieDetails(request: request)
    }
    
    func fetchCasting() {
        let request = MovieDetailsScene.FetchCasting.Request()
        interactor?.fetchCasting(request: request)
    }
    
    func fetchSimilarMovies() {
        let request = MovieDetailsScene.FetchSimilarMovies.Request()
        interactor?.fetchSimilarMovies(request: request)
    }
    
    func loadMovieReviews() {
        let request = MovieDetailsScene.LoadMovieReviews.Request()
        interactor?.loadMovieReviews(request: request)
    }
    
    func reviewMovie(with movieReview: MovieReview) {
        let request = MovieDetailsScene.ReviewMovie.Request(movieReview: movieReview)
        interactor?.reviewMovie(request: request)
    }
}

// MARK: - Display Logic
extension MovieDetailsViewController: MovieDetailsDisplayLogic {
    
    func displayMovieDetails(viewModel: MovieDetailsScene.FetchMovieDetails.ViewModel) {
        if let basicItems = viewModel.basicItems {
            detailItems.append(contentsOf: basicItems)
        }
        fetchCasting()
    }
    
    func displayCasting(viewModel: MovieDetailsScene.FetchCasting.ViewModel) {
        detailItems.append(viewModel.castingItem)
        fetchSimilarMovies()
    }
    
    func displaySimilarMovies(viewModel: MovieDetailsScene.FetchSimilarMovies.ViewModel) {
        detailItems.append(viewModel.similarMoviesItem)
    }
    
    func displayMovieReviews(viewModel: MovieDetailsScene.LoadMovieReviews.ViewModel) {
        let actionSheet = UIAlertController(title: viewModel.alertControllerTitle, message: viewModel.alertControllerMessage, preferredStyle: viewModel.alertControllerPreferredStyle)
        viewModel.actions.forEach({ (alertAction, movieReview) in
            let action = UIAlertAction(title: alertAction.title, style: alertAction.style, handler: { [weak self] _ in
                if let movieReview = movieReview {
                    self?.reviewMovie(with: movieReview)
                }
            })
            actionSheet.addAction(action)
        })
        present(actionSheet, animated: true)
    }
    
    func displayReviewMovie(viewModel: MovieDetailsScene.ReviewMovie.ViewModel) {
        
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
        case .additionalInformation(_, let releaseDate, let voteAverage):
            if let cell = cell as? AdditionalInformationTableViewCell {
                // TODO: install SDWebImage
//                cell.posterImageView.sd_setImage(with: posterImageURL) { (_, _, _, _) in
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                }
                cell.releaseDateLabel?.text = releaseDate
                cell.voteAverageLabel?.text = voteAverage
            }
        case .synopsis(let synopsis):
            cell.textLabel?.text = synopsis
        case .casting(let actors):
            cell.textLabel?.text = actors
        case .similarMovies(let similarMovies):
            cell.textLabel?.text = similarMovies
        default:
            break
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