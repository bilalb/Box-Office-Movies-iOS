//
//  NowPlayingMoviesViewControllerTests.swift
//  Box-Office-Movies
//
//  (c) Neofonie Mobile GmbH (2019)
//
//  This computer program is the sole property of Neofonie
//  Mobile GmbH (http://mobile.neofonie.de) and is protected
//  under the German Copyright Act (paragraph 69a UrhG).
//
//  All rights are reserved. Making copies, duplicating,
//  modifying, using or distributing this computer program
//  in any form, without prior written consent of Neofonie
//  Mobile GmbH, is prohibited.
//
//  Violation of copyright is punishable under the German
//  Copyright Act (paragraph 106 UrhG).
//
//  Removing this copyright statement is also a violation.

@testable import Box_Office_Movies
import XCTest

class NowPlayingMoviesViewControllerTests: XCTestCase {
    
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
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: NowPlayingMoviesViewController.identifier) as? NowPlayingMoviesViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class NowPlayingMoviesBusinessLogicSpy: NowPlayingMoviesBusinessLogic {
        
        var fetchNowPlayingMoviesCalled = false
        var fetchNextPageCalled = false
        var filterMoviesCalled = false
        var refreshMoviesCalled = false
        
        func fetchNowPlayingMovies(request: NowPlayingMovies.FetchNowPlayingMovies.Request) {
            fetchNowPlayingMoviesCalled = true
        }
        
        func fetchNextPage(request: NowPlayingMovies.FetchNextPage.Request) {
            fetchNextPageCalled = true
        }
        
        func filterMovies(request: NowPlayingMovies.FilterMovies.Request) {
            filterMoviesCalled = true
        }
        
        func refreshMovies(request: NowPlayingMovies.RefreshMovies.Request) {
            refreshMoviesCalled = true
        }
    }
    
    // MARK: Tests
    
    func testInitWithNibNameAndBundle() {
        // When
        let nowPlayingMoviesViewController = NowPlayingMoviesViewController(nibName: nil, bundle: nil)
        
        // Then
        XCTAssertNotNil(nowPlayingMoviesViewController, "init(nibName:, bundle:) should return an instance of NowPlayingMoviesViewController")
    }
    
    func testFetchNowPlayingMoviesWhenViewIsLoaded() {
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
    
    func testDisplayNowPlayingMovies() {
        // Given
        loadView()
        let viewModel = NowPlayingMovies.FetchNowPlayingMovies.ViewModel(movieItems: dummyMovieItems,
                                                                         shouldHideErrorView: true, errorDescription: nil)
        
        // When
        loadView()
        sut.displayNowPlayingMovies(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.movieItems?.count, 2, "displayNowPlayingMovies(viewModel:) should update the movieItems")
        XCTAssertFalse(sut.hasError, "displayNowPlayingMovies(viewModel:) should update hasError")
        XCTAssertTrue(sut.errorStackView.isHidden, "displayNowPlayingMovies(viewModel:) should update the isHidden of the errorStackView")
        XCTAssertNil(sut.errorStackView.errorDescription, "displayNowPlayingMovies(viewModel:) should update the errorDescription of the errorStackView")
        XCTAssertFalse(UIApplication.shared.isNetworkActivityIndicatorVisible, "displayNowPlayingMovies(viewModel:) should update the visibility of the networkActivityIndicator")
    }
    
    func testDisplayNextPageWithoutError() {
        // Given
        loadView()
        let viewModel = NowPlayingMovies.FetchNextPage.ViewModel(movieItems: dummyMovieItems,
                                                                 shouldPresentErrorAlert: false,
                                                                 errorAlertTitle: nil,
                                                                 errorAlertMessage: nil,
                                                                 errorAlertStyle: .alert,
                                                                 errorAlertActions: [])
        
        // When
        loadView()
        sut.displayNextPage(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.movieItems?.count, 2, "displayNextPage(viewModel:) should update the movieItems")
        XCTAssertFalse(sut.hasError, "displayNextPage(viewModel:) should update hasError")
        XCTAssertFalse(UIApplication.shared.isNetworkActivityIndicatorVisible, "displayNowPlayingMovies(viewModel:) should update the visibility of the networkActivityIndicator")
    }
    
    func testDisplayNextPageWithError() {
        // Given
        loadView()
        let viewModel = NowPlayingMovies.FetchNextPage.ViewModel(movieItems: nil,
                                                                 shouldPresentErrorAlert: true,
                                                                 errorAlertTitle: "Foo",
                                                                 errorAlertMessage: "Bar",
                                                                 errorAlertStyle: .alert,
                                                                 errorAlertActions: [UIAlertAction(title: "cancel", style: .cancel)])
        
        // When
        loadView()
        sut.displayNextPage(viewModel: viewModel)
        
        // Then
        XCTAssertNil(sut.movieItems, "displayNextPage(viewModel:) should update the movieItems")
        XCTAssertTrue(sut.hasError, "displayNextPage(viewModel:) should update hasError")
        XCTAssertNotNil(sut.presentedViewController, "displayNextPage(viewModel:) should present an alert with there is an error")
        XCTAssertFalse(UIApplication.shared.isNetworkActivityIndicatorVisible, "displayNowPlayingMovies(viewModel:) should update the visibility of the networkActivityIndicator")
    }
    
    func testDisplayFilterMovies() {
        // Given
        loadView()
        let viewModel = NowPlayingMovies.FilterMovies.ViewModel(movieItems: dummyMovieItems)
        
        // When
        loadView()
        sut.displayFilterMovies(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.movieItems?.count, 2, "displayFilterMovies(viewModel:) should update the movieItems")
    }
    
    func testDisplayRefreshMoviesWithoutError() {
        // Given
        loadView()
        let viewModel = NowPlayingMovies.RefreshMovies.ViewModel(movieItems: dummyMovieItems,
                                                                 shouldPresentErrorAlert: false,
                                                                 errorAlertTitle: nil,
                                                                 errorAlertMessage: nil,
                                                                 errorAlertStyle: .alert,
                                                                 errorAlertActions: [])
        
        // When
        loadView()
        sut.displayRefreshMovies(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.movieItems?.count, 2, "displayRefreshMovies(viewModel:) should update the movieItems")
        XCTAssertFalse(sut.hasError, "displayRefreshMovies(viewModel:) should update hasError")
        XCTAssertFalse(UIApplication.shared.isNetworkActivityIndicatorVisible, "displayRefreshMovies(viewModel:) should update the visibility of the networkActivityIndicator")
    }
    
    func testDisplayRefreshMoviesWithError() {
        // Given
        loadView()
        let viewModel = NowPlayingMovies.RefreshMovies.ViewModel(movieItems: nil,
                                                                 shouldPresentErrorAlert: true,
                                                                 errorAlertTitle: "Foo",
                                                                 errorAlertMessage: "Bar",
                                                                 errorAlertStyle: .alert,
                                                                 errorAlertActions: [UIAlertAction(title: "cancel", style: .cancel)])
        
        // When
        loadView()
        sut.displayRefreshMovies(viewModel: viewModel)
        
        // Then
        XCTAssertNil(sut.movieItems, "displayRefreshMovies(viewModel:) should update the movieItems")
        XCTAssertTrue(sut.hasError, "displayRefreshMovies(viewModel:) should update hasError")
        XCTAssertNotNil(sut.presentedViewController, "displayRefreshMovies(viewModel:) should present an alert with there is an error")
        XCTAssertFalse(UIApplication.shared.isNetworkActivityIndicatorVisible, "displayRefreshMovies(viewModel:) should update the visibility of the networkActivityIndicator")
    }
    
    func testNumberOfRowsInSection0() {
        // Given
        loadView()
        sut.movieItems = dummyMovieItems
        
        // When
        let numberOfRowsInSection0 = sut.tableView(sut.nowPlayingMoviesTableView, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRowsInSection0, 2)
    }
    
    func testCellForRowAtIndexPath00() {
        // Given
        loadView()
        sut.movieItems = dummyMovieItems
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        let cell = sut.tableView(sut.nowPlayingMoviesTableView, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.textLabel?.text, "Whiplash")
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

extension NowPlayingMoviesViewControllerTests {
    
    var dummyMovieItems: [MovieItem] {
        return [MovieItem(title: "Whiplash"),
                MovieItem(title: "Usual Suspects")]
    }
}

class DummySearchController: UISearchController {
    
    override var searchBar: UISearchBar {
        return UISearchBar()
    }
}
