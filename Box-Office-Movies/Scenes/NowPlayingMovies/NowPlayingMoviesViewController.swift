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
    func displayNextPage(viewModel: NowPlayingMovies.FetchNextPage.ViewModel)
    func displayFilterMovies(viewModel: NowPlayingMovies.FilterMovies.ViewModel)
    func displayRefreshMovies(viewModel: NowPlayingMovies.RefreshMovies.ViewModel)
}

class NowPlayingMoviesViewController: UIViewController {
    // MARK: Instance Properties
    var interactor: NowPlayingMoviesBusinessLogic?
    var router: (NSObjectProtocol & NowPlayingMoviesRoutingLogic & NowPlayingMoviesDataPassing)?
    var hasError = false
    
    var movieItems: [MovieItem]? {
        didSet {
            nowPlayingMoviesTableView.reloadData()
            DispatchQueue.main.async {
                let areAllCellsVisible = self.nowPlayingMoviesTableView.visibleCells.count == self.movieItems?.count
                if areAllCellsVisible && !self.hasError {
                    self.fetchNextPage()
                } else {
                    self.selectFirstItem()
                }
            }
        }
    }
    
    var indexPathForSelectedRow: IndexPath?
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var nowPlayingMoviesTableView: UITableView!
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
        configureSplitViewController()
        configureSearchController()
        configureRefreshControl()
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
    
    func configureSplitViewController() {
        splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        nowPlayingMoviesTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    func configureRefreshControl() {
        nowPlayingMoviesTableView.refreshControl = UIRefreshControl()
        nowPlayingMoviesTableView.refreshControl?.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
    }
    
    @objc func refreshControlTriggered() {
        refreshMovies()
    }
    
    func refreshMovies() {
        let request = NowPlayingMovies.RefreshMovies.Request()
        interactor?.refreshMovies(request: request)
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
        let shouldFetchNextPage = presentedViewController == nil
        if shouldFetchNextPage {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let request = NowPlayingMovies.FetchNextPage.Request()
            interactor?.fetchNextPage(request: request)
        }
    }
    
    func selectFirstItem() {
        if splitViewController?.isCollapsed == false && indexPathForSelectedRow == nil {
            let indexPathForFirstRow = IndexPath(row: 0, section: 0)
            guard movieItems?.indices.contains(indexPathForFirstRow.row) == true else {
                return
            }
            nowPlayingMoviesTableView.selectRow(at: indexPathForFirstRow, animated: true, scrollPosition: .none)
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
    
    @IBAction func errorActionButtonPressed() {
        fetchNowPlayingMovies()
    }
}

// MARK: - Display Logic
extension NowPlayingMoviesViewController: NowPlayingMoviesDisplayLogic {
    
    func displayNowPlayingMovies(viewModel: NowPlayingMovies.FetchNowPlayingMovies.ViewModel) {
        movieItems = viewModel.movieItems
        hasError = !viewModel.shouldHideErrorView
        errorStackView.isHidden = viewModel.shouldHideErrorView
        errorStackView.errorDescription = viewModel.errorDescription
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func displayNextPage(viewModel: NowPlayingMovies.FetchNextPage.ViewModel) {
        movieItems = viewModel.movieItems
        hasError = !viewModel.shouldPresentErrorAlert
        if viewModel.shouldPresentErrorAlert {
            let alertController = UIAlertController(title: viewModel.errorAlertTitle, message: viewModel.errorAlertMessage, preferredStyle: viewModel.errorAlertStyle)
            viewModel.errorAlertActions.forEach { alertAction in
                alertController.addAction(alertAction)
            }
            present(alertController, animated: true)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func displayFilterMovies(viewModel: NowPlayingMovies.FilterMovies.ViewModel) {
        movieItems = viewModel.movieItems
    }
    
    func displayRefreshMovies(viewModel: NowPlayingMovies.RefreshMovies.ViewModel) {
        movieItems = viewModel.movieItems
        nowPlayingMoviesTableView.refreshControl?.endRefreshing()
        
        hasError = !viewModel.shouldPresentErrorAlert
        if viewModel.shouldPresentErrorAlert {
            let alertController = UIAlertController(title: viewModel.errorAlertTitle, message: viewModel.errorAlertMessage, preferredStyle: viewModel.errorAlertStyle)
            viewModel.errorAlertActions.forEach { alertAction in
                alertController.addAction(alertAction)
            }
            present(alertController, animated: true)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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

// MARK: - UISplitViewControllerDelegate
extension NowPlayingMoviesViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
