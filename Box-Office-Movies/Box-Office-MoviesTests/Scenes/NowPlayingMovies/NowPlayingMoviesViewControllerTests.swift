//
//  NowPlayingMoviesViewControllerTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04.04.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Boxotop
import XCTest

typealias MovieListItem = NowPlayingMovies.MovieListItem

final class NowPlayingMoviesViewControllerTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: NowPlayingMoviesViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupNowPlayingMoviesViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupNowPlayingMoviesViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: Constants.StoryboardName.main, bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: NowPlayingMoviesViewController.identifier) as? NowPlayingMoviesViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class NowPlayingMoviesBusinessLogicSpy: NowPlayingMoviesBusinessLogic {
        
        var fetchNowPlayingMoviesCalled = false
        var loadNowPlayingMoviesCalled = false
        var shouldFetchNextPage = false
        var filterMoviesCalled = false
        var loadFavoriteMoviesCalled = false
        var loadTableViewBackgroundViewCalled = false
        var refreshFavoriteMoviesCalled = false
        
        func fetchNowPlayingMovies(request: NowPlayingMovies.FetchNowPlayingMovies.Request) {
            fetchNowPlayingMoviesCalled = true
        }

        func loadNowPlayingMovies(request: NowPlayingMovies.LoadNowPlayingMovies.Request) {
            loadNowPlayingMoviesCalled = true
        }
        
        func filterMovies(request: NowPlayingMovies.FilterMovies.Request) {
            filterMoviesCalled = true
        }
        
        func loadFavoriteMovies(request: NowPlayingMovies.LoadFavoriteMovies.Request) {
            loadFavoriteMoviesCalled = true
        }

        func loadTableViewBackgroundView(request: NowPlayingMovies.LoadTableViewBackgroundView.Request) {
            loadTableViewBackgroundViewCalled = true
        }

        func refreshFavoriteMovies(request: NowPlayingMovies.RefreshFavoriteMovies.Request) {
            refreshFavoriteMoviesCalled = true
        }
    }
    
    class NowPlayingMoviesRouterSpy: NSObject, NowPlayingMoviesRoutingLogic, NowPlayingMoviesDataPassing {
        
        var dataStore: NowPlayingMoviesDataStore?
        var routeToMovieDetailsCalled = false
        
        func routeToMovieDetails(segue: UIStoryboardSegue?) {
            routeToMovieDetailsCalled = true
        }
    }
    
    // MARK: Tests
    
    func testInitWithNibNameAndBundle() {
        // When
        let nowPlayingMoviesViewController = NowPlayingMoviesViewController(nibName: nil, bundle: nil)
        
        // Then
        XCTAssertNotNil(nowPlayingMoviesViewController, "init(nibName:, bundle:) should return an instance of NowPlayingMoviesViewController")
    }
    
    func testShouldFetchNowPlayingMoviesWhenViewIsLoaded() {
        // Given
        let spy = NowPlayingMoviesBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertNotNil(sut.searchController.searchResultsUpdater)
        XCTAssertFalse(sut.searchController.dimsBackgroundDuringPresentation)
        XCTAssertNotNil(sut.nowPlayingMoviesTableView.tableHeaderView)
        XCTAssertTrue(sut.definesPresentationContext)
        
        XCTAssertNotNil(sut.nowPlayingMoviesTableView.refreshControl)
        
        XCTAssertTrue(spy.fetchNowPlayingMoviesCalled, "viewDidLoad() should ask the interactor to fetchNowPlayingMovies")
    }
    
    func testPrepareForSegue() {
        // Given
        let spy = NowPlayingMoviesRouterSpy()
        sut.router = spy
        
        loadView()
        
        let segue = UIStoryboardSegue(identifier: Constants.SegueIdentifier.movieDetails, source: sut, destination: MovieDetailsViewController())
        let sender: Any? = nil

        // When
        sut.prepare(for: segue, sender: sender)
        
        // Then
        XCTAssertTrue(spy.routeToMovieDetailsCalled, "prepare for movie details segue should ask the router to routeToMovieDetails")
    }
    
    func testSetEditing() {
        // Given
        loadView()
        
        let editing = true
        
        // When
        sut.setEditing(editing, animated: false)
        
        // Then
        XCTAssertTrue(sut.nowPlayingMoviesTableView.isEditing, "setEditing(_:animated:) should update the isEditing")
    }
    
    func testDisplayNowPlayingMovies() {
        // Given
        loadView()
        let viewModel = NowPlayingMovies.FetchNowPlayingMovies.ViewModel(movieItems: MovieListItem.dummyInstances)
        
        // When
        sut.displayNowPlayingMovies(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.movieItems?.count, 3, "displayNowPlayingMovies(viewModel:) should update the movieItems")
    }
    
    func testDisplayFilterMovies() {
        // Given
        loadView()
        let viewModel = NowPlayingMovies.FilterMovies.ViewModel(movieItems: MovieListItem.dummyInstances)
        
        // When
        sut.displayFilterMovies(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.movieItems?.count, 3, "displayFilterMovies(viewModel:) should update the movieItems")
    }
    
    func testDisplayTableViewBackgroundView() {
        // Given
        loadView()
        
        let viewModel = NowPlayingMovies.LoadTableViewBackgroundView.ViewModel(backgroundView: nil)
        
        // When
        sut.displayTableViewBackgroundView(viewModel: viewModel)
        
        // Then
        XCTAssertNil(sut.nowPlayingMoviesTableView.backgroundView, "displayTableViewBackgroundView(viewModel:) should update the backgroundView")
    }
    
    func testDisplayFavoriteMovies() {
        // Given
        loadView()
        sut.movieItems = MovieListItem.dummyInstances
        sut.isEditing = true
        
        _ = sut.movieItems?.removeLast()
        
        let viewModel = NowPlayingMovies.LoadFavoriteMovies.ViewModel(movieItems: nil, rightBarButtonItem: nil, refreshControl: nil)
        
        // When
        sut.displayFavoriteMovies(viewModel: viewModel)
        
        // Then
        XCTAssertNil(sut.movieItems, "displayFavoriteMovies(viewModel:) should update the movieItems")
        XCTAssertNil(sut.navigationItem.rightBarButtonItem, "displayFavoriteMovies(viewModel:) should update the rightBarButtonItem")
        XCTAssertNil(sut.nowPlayingMoviesTableView.refreshControl, "displayFavoriteMovies(viewModel:) should update the refreshControl")
    }

    func test_displayRefreshFavoriteMovies_withIndexPathsForRowsToDelete_shouldUpdateMovieItems_andUpdateRightBarButtonItem() {
        // Given
        loadView()
        sut.movieItems = MovieListItem.dummyInstances
        sut.isEditing = true

        _ = sut.movieItems?.removeLast()

        let viewModel = NowPlayingMovies.RefreshFavoriteMovies.ViewModel(shouldSetMovieItems: true, movieItems: sut.movieItems, indexPathsForRowsToDelete: [IndexPath(row: 0, section: 0)], indexPathsForRowsToInsert: nil, shouldSetRightBarButtonItem: true, rightBarButtonItem: UIBarButtonItem())

        // When
        sut.displayRefreshFavoriteMovies(viewModel: viewModel)

        // Then
        XCTAssertEqual(sut.movieItems?.count, 2, "displayRefreshFavoriteMovies(viewModel:) should update the movieItems")
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem, "displayRefreshFavoriteMovies(viewModel:) should update the rightBarButtonItem")
    }

    func test_displayRefreshFavoriteMovies_withIndexPathsForRowsToInsert_shouldUpdateMovieItems_andUpdateRightBarButtonItem() {
        // Given
        loadView()
        sut.movieItems = MovieListItem.dummyInstances
        sut.isEditing = true

        sut.movieItems?.append(MovieListItem.dummyInstance)

        let viewModel = NowPlayingMovies.RefreshFavoriteMovies.ViewModel(shouldSetMovieItems: true, movieItems: sut.movieItems, indexPathsForRowsToDelete: nil, indexPathsForRowsToInsert: [IndexPath(row: 1, section: 0)], shouldSetRightBarButtonItem: true, rightBarButtonItem: UIBarButtonItem())

        // When
        sut.displayRefreshFavoriteMovies(viewModel: viewModel)

        // Then
        XCTAssertEqual(sut.movieItems?.count, 4, "displayRefreshFavoriteMovies(viewModel:) should update the movieItems")
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem, "displayRefreshFavoriteMovies(viewModel:) should update the rightBarButtonItem")
    }
    
    func testNumberOfRowsInSection0() {
        // Given
        let spy = NowPlayingMoviesBusinessLogicSpy()
        sut.interactor = spy

        loadView()
        sut.movieItems = MovieListItem.dummyInstances
        
        // When
        let numberOfRowsInSection0 = sut.tableView(sut.nowPlayingMoviesTableView, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRowsInSection0, 3)
        XCTAssertTrue(spy.loadTableViewBackgroundViewCalled, "tableView(_:numberOfRowsInSection:) should ask the interactor to loadTableViewBackgroundView")
    }

    func test_cellForRowAtMovieItemIndexPath() {
        // Given
        loadView()
        sut.movieItems = MovieListItem.dummyInstances
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        let cell = sut.tableView(sut.nowPlayingMoviesTableView, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.textLabel?.text, "Whiplash")
    }

    func test_cellForRowAtErrorItemIndexPath() {
        // Given
        let spy = NowPlayingMoviesBusinessLogicSpy()
        sut.interactor = spy

        loadView()
        sut.movieItems = MovieListItem.dummyInstances
        let indexPath = IndexPath(row: 2, section: 0)

        // When
        let cell = sut.tableView(sut.nowPlayingMoviesTableView, cellForRowAt: indexPath)

        // Then
        guard let errorTableViewCell = cell as? ErrorTableViewCell else {
            XCTFail("The cell should be an instance of ErrorTableViewCell")
            return
        }
        XCTAssertEqual(errorTableViewCell.messageLabel.text, "An error occurred")

        errorTableViewCell.retryButtonAction?()
        XCTAssertTrue(spy.fetchNowPlayingMoviesCalled, "The retryButtonAction should ask the interactor to fetchNowPlayingMovies")
    }
    
    func testCanEditRowAtIndexPath00() {
        // Given
        loadView()
        sut.movieItems = MovieListItem.dummyInstances
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        let isRowEditable = sut.tableView(sut.nowPlayingMoviesTableView, canEditRowAt: indexPath)
        
        // Then
        XCTAssertEqual(isRowEditable, sut.isEditing)
    }
    
    func testCommitEditingStyleForRowAtIndexPath00() {
        // Given
        let spy = NowPlayingMoviesBusinessLogicSpy()
        sut.interactor = spy
        loadView()
        sut.movieItems = MovieListItem.dummyInstances
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        sut.tableView(sut.nowPlayingMoviesTableView, commit: .delete, forRowAt: indexPath)
        
        // Then
        XCTAssertTrue(spy.refreshFavoriteMoviesCalled, "committing delete should call refreshFavoriteMovies")
    }
    
    func testUpdateSearchResults() {
        // Given
        let spy = NowPlayingMoviesBusinessLogicSpy()
        sut.interactor = spy
        loadView()
        
        let searchController = DummySearchController()
        searchController.searchBar.text = ""
        
        // When
        sut.updateSearchResults(for: searchController)
        
        // Then
        XCTAssertTrue(spy.filterMoviesCalled, "updateSearchResults(for:) should ask the interactor to filterMovies")
    }
    
    func testCollapseSecondaryOntoPrimary() {
        // When
        let collapse = sut.splitViewController(UISplitViewController(), collapseSecondary: UIViewController(), onto: UIViewController())
        
        // Then
        XCTAssertTrue(collapse)
    }
}

extension MovieListItem {
    
    static var dummyInstances: [MovieListItem] {
        return [MovieListItem.movie(title: "Whiplash"),
                MovieListItem.movie(title: "Usual Suspects"),
                MovieListItem.error(description: "An error occurred", mode: .refreshMovieList)]
    }

    static var dummyInstance: MovieListItem {
        return MovieListItem.movie(title: "Split")
    }
}

final class DummySearchController: UISearchController {
    
    override var searchBar: UISearchBar {
        return UISearchBar()
    }
}
