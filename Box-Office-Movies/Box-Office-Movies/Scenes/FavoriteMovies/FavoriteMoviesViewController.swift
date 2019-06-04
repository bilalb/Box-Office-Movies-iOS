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
    func displayRemoveMovieFromFavorites(viewModel: FavoriteMovies.RemoveMovieFromFavorites.ViewModel)
}

class FavoriteMoviesViewController: UIViewController {
    // MARK: Instance Properties
    var interactor: FavoriteMoviesBusinessLogic?
    var router: (NSObjectProtocol & FavoriteMoviesRoutingLogic & FavoriteMoviesDataPassing)?
    
    var movieItems: [MovieItem]?
    
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
}

// MARK: - Private Functions
private extension FavoriteMoviesViewController {
    
    func loadFavoriteMovies() {
        let request = FavoriteMovies.LoadFavoriteMovies.Request()
        interactor?.loadFavoriteMovies(request: request)
    }
    
    func removeMovieFromFavorites(at indexPath: IndexPath) {
        let request = FavoriteMovies.RemoveMovieFromFavorites.Request(indexPathForMovieToRemove: indexPath)
        interactor?.removeMovieFromFavorites(request: request)
    }
}

// MARK: - Display Logic
extension FavoriteMoviesViewController: FavoriteMoviesDisplayLogic {
    
    func displayFavoriteMovies(viewModel: FavoriteMovies.LoadFavoriteMovies.ViewModel) {
        movieItems = viewModel.movieItems
        favoriteMoviesTableView.reloadData()
    }
    
    func displayRemoveMovieFromFavorites(viewModel: FavoriteMovies.RemoveMovieFromFavorites.ViewModel) {
        movieItems = viewModel.movieItems
        favoriteMoviesTableView.deleteRows(at: viewModel.indexPathsForRowsToDelete, with: .automatic)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeMovieFromFavorites(at: indexPath)
        }
    }
}
