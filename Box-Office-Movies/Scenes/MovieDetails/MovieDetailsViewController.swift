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
        
        if let basicItem = detailItem as? MovieDetailsScene.FetchMovieDetails.ViewModel.BasicItem {
            switch basicItem {
            case .title(let value):
                cell.textLabel?.text = value
            case .synopsis(let value):
                cell.textLabel?.text = value
            }
        }
        
        if let castingItem = detailItem as? MovieDetailsScene.FetchCasting.ViewModel.CastingItem {
            cell.textLabel?.text = castingItem.actors
        }
        
        if let similarMoviesItem = detailItem as? MovieDetailsScene.FetchSimilarMovies.ViewModel.SimilarMoviesItem {
            cell.textLabel?.text = similarMoviesItem.similarMovies
        }
        
        return cell
    }
}
