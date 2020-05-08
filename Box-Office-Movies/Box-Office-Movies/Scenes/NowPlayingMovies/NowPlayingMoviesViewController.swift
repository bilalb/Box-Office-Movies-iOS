//
//  NowPlayingMoviesViewController.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol NowPlayingMoviesDisplayLogic: class {
    func displayNowPlayingMovies(viewModel: NowPlayingMovies.FetchNowPlayingMovies.ViewModel)
    func displayFilterMovies(viewModel: NowPlayingMovies.FilterMovies.ViewModel)
    func displayTableViewBackgroundView(viewModel: NowPlayingMovies.LoadTableViewBackgroundView.ViewModel)

    func displayFavoriteMovies(viewModel: NowPlayingMovies.LoadFavoriteMovies.ViewModel)
    func displayRefreshFavoriteMovies(viewModel: NowPlayingMovies.RefreshFavoriteMovies.ViewModel)
}

final class NowPlayingMoviesViewController: UIViewController {
    // MARK: Instance Properties
    var interactor: NowPlayingMoviesBusinessLogic?
    var router: (NSObjectProtocol & NowPlayingMoviesRoutingLogic & NowPlayingMoviesDataPassing)?

    typealias MovieListItem = NowPlayingMovies.MovieListItem
    typealias SegmentedControlSegmentIndex = NowPlayingMovies.SegmentedControlSegmentIndex

    var movieItems: [MovieListItem]? {
        didSet {
            if !isEditing {
                nowPlayingMoviesTableView.reloadData()
                DispatchQueue.main.async {
                    let allCellsAreVisible = self.nowPlayingMoviesTableView.visibleCells.count == self.movieItems?.count
                    if self.movieItems?.isEmpty == false && allCellsAreVisible {
                        self.fetchNextPage()
                    } else {
                        self.selectFirstItem()
                    }
                }
            }
        }
    }

    var movieDetailsViewController: MovieDetailsViewController? {
        return splitViewController?.detailViewController as? MovieDetailsViewController
    }

    var isSplitViewControllerCollapsed: Bool {
        return splitViewController?.isCollapsed == true
    }
    
    var indexPathForSelectedRow: IndexPath?
    let searchController = UISearchController(searchResultsController: nil)

    #if !targetEnvironment(macCatalyst)
    let refreshControl = UIRefreshControl()
    #endif

    @IBOutlet weak var segmentedControl: UISegmentedControl!
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
    override func awakeFromNib() {
        super.awakeFromNib()
        configureSplitViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentedControl()
        configureSearchController()

        #if !targetEnvironment(macCatalyst)
        configureRefreshControl()
        #endif

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
        super.prepare(for: segue, sender: sender)
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
        refreshCellsDisclosureIndicatorsDisplay()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        nowPlayingMoviesTableView.setEditing(editing, animated: animated)
    }

    func refreshFavoriteMovies(with refreshSource: RefreshSource) {
        let request = NowPlayingMovies.RefreshFavoriteMovies.Request(refreshSource: refreshSource,
                                                                     editButtonItem: editButtonItem,
                                                                     searchText: searchController.searchBar.text,
                                                                     isSearchControllerActive: searchController.isActive)
        interactor?.refreshFavoriteMovies(request: request)
    }

    func fetchNowPlayingMovies(mode: NowPlayingMovies.FetchNowPlayingMovies.Request.Mode = .fetchFirstPage) {
        prepareNowPlayingMovies()
        UIApplication.shared.setNetworkActivityIndicatorVisibility(true)

        let request = NowPlayingMovies.FetchNowPlayingMovies.Request(mode: mode)
        interactor?.fetchNowPlayingMovies(request: request)
    }
}

// MARK: - Private Functions
private extension NowPlayingMoviesViewController {

    func configureSplitViewController() {
        splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible
        #if targetEnvironment(macCatalyst)
            splitViewController?.primaryBackgroundStyle = .sidebar
        #endif
    }

    func configureSegmentedControl() {
        guard segmentedControl.numberOfSegments == 2 else { return }
        let titles = [NSLocalizedString("nowPlaying", comment: "nowPlaying"),
                      NSLocalizedString("favorites", comment: "favorites")]
        for i in 0 ..< segmentedControl.numberOfSegments {
            segmentedControl.setTitle(titles[safe: i], forSegmentAt: i)
        }
    }

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        #if targetEnvironment(macCatalyst)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        #else
        nowPlayingMoviesTableView.tableHeaderView = searchController.searchBar
        #endif
        definesPresentationContext = true
    }

    #if !targetEnvironment(macCatalyst)
    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
    }
    #endif
    
    @objc func refreshControlTriggered() {
        fetchNowPlayingMovies(mode: .refreshMovieList)
    }

    func configureTableView() {
        // To change the color (to the default system background color) behind the table's sections and rows
        nowPlayingMoviesTableView.backgroundView = UIView()

        let nib = UINib(nibName: Constants.NibName.errorTableViewCell, bundle: Bundle.main)
        nowPlayingMoviesTableView.register(nib, forCellReuseIdentifier: ErrorTableViewCell.identifier)
    }

    func filterMovies(with searchText: String) {
        let request = NowPlayingMovies.FilterMovies.Request(searchText: searchText, isSearchControllerActive: searchController.isActive)
        interactor?.filterMovies(request: request)
    }

    func prepareNowPlayingMovies() {
        setEditing(false, animated: true)
        navigationItem.setRightBarButton(nil, animated: true)
        
        #if !targetEnvironment(macCatalyst)
        nowPlayingMoviesTableView.refreshControl = refreshControl
        #endif
    }

    func loadNowPlayingMovies() {
        prepareNowPlayingMovies()

        let request = NowPlayingMovies.LoadNowPlayingMovies.Request()
        interactor?.loadNowPlayingMovies(request: request)
    }

    func fetchNextPage() {
        guard presentedViewController == nil,
            interactor?.shouldFetchNextPage == true else { return }

        fetchNowPlayingMovies(mode: .fetchNextPage)
    }

    func selectFirstItem() {
        if !isSplitViewControllerCollapsed && indexPathForSelectedRow == nil {
            let indexPathForFirstRow = IndexPath(row: 0, section: 0)
            guard movieItems?.indices.contains(indexPathForFirstRow.row) == true else { return }
            nowPlayingMoviesTableView.selectRow(at: indexPathForFirstRow, animated: true, scrollPosition: .none)
            indexPathForSelectedRow = nowPlayingMoviesTableView.indexPathForSelectedRow
            performSegue(withIdentifier: Constants.SegueIdentifier.movieDetails, sender: nil)
        }
    }

    func deselectItem(_ animated: Bool) {
        if isSplitViewControllerCollapsed {
            if let indexPathForSelectedRow = nowPlayingMoviesTableView.indexPathForSelectedRow {
                nowPlayingMoviesTableView.deselectRow(at: indexPathForSelectedRow, animated: animated)
            }
        }
    }

    func refreshCellsDisclosureIndicatorsDisplay() {
        nowPlayingMoviesTableView.visibleCells.forEach { visibleCell in
            if let movieTableViewCell = visibleCell as? MovieTableViewCell {
                movieTableViewCell.setDisclosureIndicator(isSplitViewControllerCollapsed)
            }
        }
    }

    @IBAction func segmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case SegmentedControlSegmentIndex.all.rawValue:
            loadNowPlayingMovies()
        case SegmentedControlSegmentIndex.favorites.rawValue:
            loadFavoriteMovies()
        default:
            break
        }
        #if targetEnvironment(macCatalyst)
            navigationItem.searchController?.isActive = false
        #endif
    }

    func loadTableViewBackgroundView() {
        let request = NowPlayingMovies.LoadTableViewBackgroundView.Request(searchText: searchController.searchBar.text)
        interactor?.loadTableViewBackgroundView(request: request)
    }

    // TODO: to improve
    func animateActivityIndicators(_ animated: Bool) {
        UIApplication.shared.setNetworkActivityIndicatorVisibility(animated)

        if !animated {
            nowPlayingMoviesTableView.refreshControl?.endRefreshing()
        }
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

    private func reloadMovieDetailsFavoriteToggle() {
        movieDetailsViewController?.loadFavoriteToggle()
    }

    private func loadFavoriteMovies() {
        animateActivityIndicators(false)
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
        animateActivityIndicators(false)

        movieItems = viewModel.movieItems
    }

    func displayFilterMovies(viewModel: NowPlayingMovies.FilterMovies.ViewModel) {
        movieItems = viewModel.movieItems
    }

    func displayTableViewBackgroundView(viewModel: NowPlayingMovies.LoadTableViewBackgroundView.ViewModel) {
        nowPlayingMoviesTableView.backgroundView = viewModel.backgroundView
        #if targetEnvironment(macCatalyst)
        navigationItem.searchController = viewModel.searchController
        #else
        searchController.searchBar.setEnabled(viewModel.isSearchBarEnabled)
        #endif
    }

    func displayFavoriteMovies(viewModel: NowPlayingMovies.LoadFavoriteMovies.ViewModel) {
        movieItems = viewModel.movieItems
        navigationItem.setRightBarButton(viewModel.rightBarButtonItem, animated: true)
        nowPlayingMoviesTableView.refreshControl = viewModel.refreshControl
    }

    func displayRefreshFavoriteMovies(viewModel: NowPlayingMovies.RefreshFavoriteMovies.ViewModel) {
        if viewModel.shouldSetMovieItems {
            if isEditing {
                movieItems = viewModel.movieItems
            } else {
                // Set/Reset `isEditing` in order to make the `didSet` of `movieItems` not calling `nowPlayingMoviesTableView.reloadData()`
                isEditing = true
                movieItems = viewModel.movieItems
                isEditing = false
            }
        }

        if let indexPathsForRowsToDelete = viewModel.indexPathsForRowsToDelete {
            nowPlayingMoviesTableView.deleteRows(at: indexPathsForRowsToDelete, with: .automatic)
        }
        if let indexPathsForRowsToInsert = viewModel.indexPathsForRowsToInsert {
            nowPlayingMoviesTableView.insertRows(at: indexPathsForRowsToInsert, with: .automatic)
        }

        if viewModel.shouldSetRightBarButtonItem {
            navigationItem.setRightBarButton(viewModel.rightBarButtonItem, animated: true)
        }

        reloadMovieDetailsFavoriteToggle()
    }
}

// MARK: - UITableViewDataSource
extension NowPlayingMoviesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadTableViewBackgroundView()
        return movieItems?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieItem = movieItems?[safe: indexPath.row] else { return UITableViewCell() }

        let cellIdentifier = movieItem.cellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        switch movieItem {
        case .movie(let title):
            if let movieTableViewCell = cell as? MovieTableViewCell {
                movieTableViewCell.textLabel?.text = title
                movieTableViewCell.setDisclosureIndicator(isSplitViewControllerCollapsed)
            }
        case .error(let description, let mode):
            if let errorTableViewCell = cell as? ErrorTableViewCell {
                errorTableViewCell.messageLabel?.text = description
                errorTableViewCell.retryButtonAction = { [weak self] in
                    _ = self?.movieItems?.removeLast()
                    self?.movieItems?.append(.loader)
                    self?.fetchNowPlayingMovies(mode: mode)
                }
            }
        case .loader:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditing
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            refreshFavoriteMovies(with: .indexPathForMovieToRemove(indexPath))
        }
    }
}

// MARK: - UITableViewDelegate
extension NowPlayingMoviesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tableView.isTracking || tableView.isDecelerating,
            let movieItems = movieItems,
            indexPath.row == (movieItems.count - 1) else { return }

        fetchNextPage()
    }
}

// MARK: - UISearchResultsUpdating
extension NowPlayingMoviesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterMovies(with: searchText)
    }
}

// MARK: - UISplitViewControllerDelegate
extension NowPlayingMoviesViewController: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return indexPathForSelectedRow == nil
    }
}

extension UISearchBar {

    func setEnabled(_ enabled: Bool) {
        isUserInteractionEnabled = enabled
        alpha = enabled ? 1 : 0.5
    }
}
