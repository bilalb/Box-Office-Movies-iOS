//
//  NowPlayingMoviesViewController.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol NowPlayingMoviesDisplayLogic: class {
    func displayNowPlayingMovies(viewModel: NowPlayingMovies.FetchNowPlayingMovies.ViewModel)
    func displayFilterMovies(viewModel: NowPlayingMovies.FilterMovies.ViewModel)
}

class NowPlayingMoviesViewController: UIViewController {
    // MARK: Instance Properties
    var interactor: NowPlayingMoviesBusinessLogic?
    var router: (NSObjectProtocol & NowPlayingMoviesRoutingLogic & NowPlayingMoviesDataPassing)?
    
    var movieItems: [MovieItem]? {
        didSet {
            nowPlayingMoviesTableView.reloadData()
            DispatchQueue.main.async {
                self.selectFirstItem()
                
                let shouldFetchNextPage = self.nowPlayingMoviesTableView.visibleCells.count == self.movieItems?.count
                if shouldFetchNextPage {
                    self.fetchNextPage()
                }
            }
        }
    }
    
    var indexPathForSelectedRow: IndexPath?
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var nowPlayingMoviesTableView: UITableView!
    
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
        configureSearchController()
        fetchNowPlayingMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectItem(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        indexPathForSelectedRow = nowPlayingMoviesTableView.indexPathForSelectedRow
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        selectFirstItem()
    }
}

// MARK: - Private Functions
private extension NowPlayingMoviesViewController {
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            nowPlayingMoviesTableView.tableHeaderView = searchController.searchBar
        }
        
        definesPresentationContext = true
    }
    
    func filterMovies(with searchText: String) {
        let request = NowPlayingMovies.FilterMovies.Request(searchText: searchText, isSearchControllerActive: searchController.isActive)
        interactor?.filterMovies(request: request)
    }
    
    func fetchNowPlayingMovies() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let request = NowPlayingMovies.FetchNowPlayingMovies.Request()
        interactor?.fetchNowPlayingMovies(request: request)
    }
    
    func fetchNextPage() {
        fetchNowPlayingMovies()
    }
    
    func selectFirstItem() {
        if splitViewController?.isCollapsed == false && indexPathForSelectedRow == nil {
            let indexPathForFirstRow = IndexPath(row: 0, section: 0)
            guard movieItems?.indices.contains(indexPathForFirstRow.row) == true else {
                return
            }
            nowPlayingMoviesTableView.selectRow(at: indexPathForFirstRow, animated: true, scrollPosition: .top)
            indexPathForSelectedRow = nowPlayingMoviesTableView.indexPathForSelectedRow
            performSegue(withIdentifier: Constants.SegueIdentifier.movieDetails, sender: nil)
        }
    }
    
    func deselectItem(_ animated: Bool) {
        if splitViewController?.isCollapsed == true {
            if let indexPathForSelectedRow = nowPlayingMoviesTableView.indexPathForSelectedRow {
                nowPlayingMoviesTableView.deselectRow(at: indexPathForSelectedRow, animated: animated)
            }
        }
    }
}

// MARK: - Display Logic
extension NowPlayingMoviesViewController: NowPlayingMoviesDisplayLogic {
    
    func displayNowPlayingMovies(viewModel: NowPlayingMovies.FetchNowPlayingMovies.ViewModel) {
        movieItems = viewModel.movieItems
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func displayFilterMovies(viewModel: NowPlayingMovies.FilterMovies.ViewModel) {
        movieItems = viewModel.movieItems
    }
}

// MARK: - UITableViewDataSource
extension NowPlayingMoviesViewController: UITableViewDataSource {
    
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
extension NowPlayingMoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let movieItems = movieItems else { return }
        if (tableView.isTracking || tableView.isDecelerating), indexPath.row == (movieItems.count - 1) {
            fetchNextPage()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension NowPlayingMoviesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        filterMovies(with: searchText)
    }
}
