//
//  FavoriteMoviesViewController.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 27.05.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol FavoriteMoviesDisplayLogic: class {
    func displayFavoriteMovies(viewModel: FavoriteMovies.LoadFavoriteMovies.ViewModel)
}

class FavoriteMoviesViewController: UIViewController {
    // MARK: Instance Properties
    var interactor: FavoriteMoviesBusinessLogic?
    var router: (NSObjectProtocol & FavoriteMoviesRoutingLogic & FavoriteMoviesDataPassing)?
    
    var movieItems: [MovieItem]? {
        didSet {
            favoriteMoviesTableView.reloadData()
        }
    }
    
    var indexPathForSelectedRow: IndexPath?
    
    @IBOutlet weak var favoriteMoviesTableView: UITableView!

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
        loadFavoriteMovies()
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
private extension FavoriteMoviesViewController {
    
    func loadFavoriteMovies() {
        let request = FavoriteMovies.LoadFavoriteMovies.Request()
        interactor?.loadFavoriteMovies(request: request)
    }
    
    func removeMovieFromFavorites(at index: Int) {
        let request = FavoriteMovies.RemoveMovieFromFavorites.Request(indexForMovieToRemove: index)
        interactor?.removeMovieFromFavorites(request: request)
    }
}

// MARK: - Display Logic
extension FavoriteMoviesViewController: FavoriteMoviesDisplayLogic {
    
    func displayFavoriteMovies(viewModel: FavoriteMovies.LoadFavoriteMovies.ViewModel) {
        movieItems = viewModel.movieItems
    }
}

// MARK: - UITableViewDataSource
extension FavoriteMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            movieItems?.indices.contains(indexPath.row) == true,
            let movieItem = movieItems?[indexPath.row]
        else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.movieTableViewCell, for: indexPath)
        cell.textLabel?.text = movieItem.title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteMoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deletionAction = UITableViewRowAction(style: .destructive,
                                                  title: NSLocalizedString("deleteFavorite", comment: "deleteFavorite")) { [weak self] (_, indexPath) in
                                                    self?.removeMovieFromFavorites(at: indexPath.row)
        }
        return [deletionAction]
    }
}
