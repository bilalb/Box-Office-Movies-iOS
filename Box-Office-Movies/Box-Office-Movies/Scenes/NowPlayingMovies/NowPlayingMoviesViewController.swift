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
    func displayTableViewBackgroundView(viewModel: NowPlayingMovies.LoadTableViewBackgroundView.ViewModel)

    func displayFavoriteMovies(viewModel: NowPlayingMovies.LoadFavoriteMovies.ViewModel)
    func displayRemoveMovieFromFavorites(viewModel: NowPlayingMovies.RemoveMovieFromFavorites.ViewModel)
}

class NowPlayingMoviesViewController: UIViewController {
    // MARK: Instance Properties
    var interactor: NowPlayingMoviesBusinessLogic?
    var router: (NSObjectProtocol & NowPlayingMoviesRoutingLogic & NowPlayingMoviesDataPassing)?
    var hasError = false
    
    var movieItems: [MovieItem]? {
        didSet {
            if !isEditing {
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
    }
    
    var indexPathForSelectedRow: IndexPath?
    let searchController = UISearchController(searchResultsController: nil)
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var nowPlayingMoviesTableView: UITableView!
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
    override func awakeFromNib() {
        super.awakeFromNib()
        configureSplitViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentedControl()
        configureSearchController()
        configureRefreshControl()
        configureEditButtonItem()
        configureTableView()
        fetchNowPlayingMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectItem(animated)
        refreshFavoriteMovies()
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        nowPlayingMoviesTableView.setEditing(editing, animated: animated)
    }
}

// MARK: - Private Functions
private extension NowPlayingMoviesViewController {
    
    func configureSplitViewController() {
        splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible
    }
    
    func configureSegmentedControl() {
        guard segmentedControl.numberOfSegments == 2 else {
            return
        }
        let titles = [NSLocalizedString("nowPlaying", comment: "nowPlaying"),
                      NSLocalizedString("favorites", comment: "favorites")]
        for i in 0 ..< segmentedControl.numberOfSegments {
            segmentedControl.setTitle(titles[i], forSegmentAt: i)
        }
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        nowPlayingMoviesTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
    }
    
    @objc func refreshControlTriggered() {
        refreshMovies()
    }
    
    func configureTableView() {
        // To change the color (to the default system background color) behind the table's sections and rows
        nowPlayingMoviesTableView.backgroundView = UIView()
    }
    
    func refreshMovies() {
        if #available(iOS 13.0, *) { } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let request = NowPlayingMovies.RefreshMovies.Request()
        interactor?.refreshMovies(request: request)
    }
    
    func filterMovies(with searchText: String) {
        let request = NowPlayingMovies.FilterMovies.Request(searchText: searchText, isSearchControllerActive: searchController.isActive)
        interactor?.filterMovies(request: request)
    }
    
    func fetchNowPlayingMovies() {
        setEditing(false, animated: true)
        navigationItem.setRightBarButton(nil, animated: true)
        nowPlayingMoviesTableView.refreshControl = refreshControl

        if #available(iOS 13.0, *) { } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        activityIndicatorView.startAnimating()

        let request = NowPlayingMovies.FetchNowPlayingMovies.Request()
        interactor?.fetchNowPlayingMovies(request: request)
    }
    
    func fetchNextPage() {
        guard
            router?.dataStore?.state == .allMovies,
            presentedViewController == nil
        else {
            return
        }

        if #available(iOS 13.0, *) { } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }

        let request = NowPlayingMovies.FetchNextPage.Request()
        interactor?.fetchNextPage(request: request)
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
    
    @IBAction func segmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case SegmentedControlSegmentIndex.all.rawValue:
            fetchNowPlayingMovies()
        case SegmentedControlSegmentIndex.favorites.rawValue:
            loadFavoriteMovies()
        default:
            break
        }
    }
    
    func loadTableViewBackgroundView() {
        let request = NowPlayingMovies.LoadTableViewBackgroundView.Request(searchText: searchController.searchBar.text)
        interactor?.loadTableViewBackgroundView(request: request)
    }
}

// MARK: - Favorite movies - Private Functions
extension NowPlayingMoviesViewController {
    
    private func configureEditButtonItem() {
        editButtonItem.action = #selector(editButtonItemPressed)
    }
    
    @objc private func editButtonItemPressed() {
        setEditing(!isEditing, animated: true)
    }
    
    private func removeMovieFromFavorites(at indexPath: IndexPath) {
        let request = NowPlayingMovies.RemoveMovieFromFavorites.Request(indexPathForMovieToRemove: indexPath, editButtonItem: editButtonItem)
        interactor?.removeMovieFromFavorites(request: request)
    }
    
    private func loadFavoriteMovies() {
        let request = NowPlayingMovies.LoadFavoriteMovies.Request(editButtonItem: editButtonItem)
        interactor?.loadFavoriteMovies(request: request)
    }
    
    func refreshFavoriteMovies() {
        if segmentedControl.selectedSegmentIndex == SegmentedControlSegmentIndex.favorites.rawValue {
            loadFavoriteMovies()
        }
    }
}

// MARK: - Display Logic
extension NowPlayingMoviesViewController: NowPlayingMoviesDisplayLogic {
    
    func displayNowPlayingMovies(viewModel: NowPlayingMovies.FetchNowPlayingMovies.ViewModel) {
        if #available(iOS 13.0, *) { } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        activityIndicatorView.stopAnimating()

        movieItems = viewModel.movieItems
        hasError = !viewModel.shouldHideErrorView
        errorStackView.isHidden = viewModel.shouldHideErrorView
        errorStackView.errorDescription = viewModel.errorDescription
    }
    
    func displayNextPage(viewModel: NowPlayingMovies.FetchNextPage.ViewModel) {
        if #available(iOS 13.0, *) { } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        movieItems = viewModel.movieItems
        hasError = viewModel.shouldPresentErrorAlert
        if viewModel.shouldPresentErrorAlert {
            let alertController = UIAlertController(title: viewModel.errorAlertTitle, message: viewModel.errorAlertMessage, preferredStyle: viewModel.errorAlertStyle)
            viewModel.errorAlertActions.forEach { alertAction in
                alertController.addAction(alertAction)
            }
            present(alertController, animated: true)
        }
    }
    
    func displayFilterMovies(viewModel: NowPlayingMovies.FilterMovies.ViewModel) {
        movieItems = viewModel.movieItems
    }
    
    func displayRefreshMovies(viewModel: NowPlayingMovies.RefreshMovies.ViewModel) {
        if #available(iOS 13.0, *) { } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        movieItems = viewModel.movieItems
        nowPlayingMoviesTableView.refreshControl?.endRefreshing()
        
        hasError = viewModel.shouldPresentErrorAlert
        if viewModel.shouldPresentErrorAlert {
            let alertController = UIAlertController(title: viewModel.errorAlertTitle, message: viewModel.errorAlertMessage, preferredStyle: viewModel.errorAlertStyle)
            viewModel.errorAlertActions.forEach { alertAction in
                alertController.addAction(alertAction)
            }
            present(alertController, animated: true)
        }
    }
    
    func displayTableViewBackgroundView(viewModel: NowPlayingMovies.LoadTableViewBackgroundView.ViewModel) {
        nowPlayingMoviesTableView.backgroundView = viewModel.backgroundView
    }
    
    func displayFavoriteMovies(viewModel: NowPlayingMovies.LoadFavoriteMovies.ViewModel) {
        movieItems = viewModel.movieItems
        navigationItem.setRightBarButton(viewModel.rightBarButtonItem, animated: true)
        nowPlayingMoviesTableView.refreshControl = viewModel.refreshControl
    }
    
    func displayRemoveMovieFromFavorites(viewModel: NowPlayingMovies.RemoveMovieFromFavorites.ViewModel) {
        movieItems = viewModel.movieItems
        nowPlayingMoviesTableView.deleteRows(at: viewModel.indexPathsForRowsToDelete, with: .automatic)
        navigationItem.setRightBarButton(viewModel.rightBarButtonItem, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension NowPlayingMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadTableViewBackgroundView()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditing
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeMovieFromFavorites(at: indexPath)
        }
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
        return indexPathForSelectedRow == nil ? true : false
    }
}
