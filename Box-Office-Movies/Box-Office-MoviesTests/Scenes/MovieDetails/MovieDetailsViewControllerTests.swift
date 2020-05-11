//
//  MovieDetailsViewControllerTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04.04.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Boxotop
import XCTest

final class MovieDetailsViewControllerTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: MovieDetailsViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupMovieDetailsViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupMovieDetailsViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: Constants.StoryboardName.main, bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: MovieDetailsViewController.identifier) as? MovieDetailsViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class MovieDetailsBusinessLogicSpy: MovieDetailsBusinessLogic {
        
        var fetchMovieDetailsCalled = false
        var loadMovieReviewsCalled = false
        var reviewMovieCalled = false
        var loadFavoriteToggleCalled = false
        var isMovieAddedToFavoritesCalled = false
        var loadTableViewBackgroundViewCalled = false

        func fetchMovieDetails(request: MovieDetailsScene.FetchMovieDetails.Request) {
            fetchMovieDetailsCalled = true
        }
        
        func loadMovieReviews(request: MovieDetailsScene.LoadMovieReviews.Request) {
            loadMovieReviewsCalled = true
        }
        
        func reviewMovie(request: MovieDetailsScene.ReviewMovie.Request) {
            reviewMovieCalled = true
        }
        
        func loadFavoriteToggle(request: MovieDetailsScene.LoadFavoriteToggle.Request) {
            loadFavoriteToggleCalled = true
        }
        
        func isMovieAddedToFavorites() -> Bool? {
            isMovieAddedToFavoritesCalled = true
            return nil
        }

        func loadTableViewBackgroundView(request: MovieDetailsScene.LoadTableViewBackgroundView.Request) {
            loadTableViewBackgroundViewCalled = true
        }
    }
    
    // MARK: Tests
    
    func testInitWithNibNameAndBundle() {
        // When
        let movieDetailsViewController = MovieDetailsViewController(nibName: nil, bundle: nil)
        
        // Then
        XCTAssertNotNil(movieDetailsViewController, "init(nibName:, bundle:) should return an instance of MovieDetailsViewController")
    }
    
    func test_viewWillAppear_shouldCallLoadFavoriteToggle() {
        // Given
        let spy = MovieDetailsBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        sut.viewWillAppear(false)
        
        // Then
        XCTAssertTrue(spy.loadFavoriteToggleCalled)
    }
    
    func testShouldStopAnimatingActivityIndicatorViewWhenMovieIdentifierIsNilAndViewIsLoaded() {
        // When
        loadView()
        
        // Then
        XCTAssertFalse(sut.activityIndicatorView.isAnimating, "viewDidLoad() should stop animating activityIndicatorView")
    }
    
    func testDisplayMovieDetails() {
        // Given
        let viewModel = MovieDetailsScene.FetchMovieDetails.ViewModel(detailItems: DetailItem.dummyInstances, shouldShowNetworkActivityIndicator: true)
        
        // When
        loadView()
        sut.displayMovieDetails(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.detailItems.count, 7, "displayMovieDetails(viewModel:) should append some detailItems to its detailItems")
        XCTAssertFalse(sut.activityIndicatorView.isAnimating, "displayMovieDetails(viewModel:) should stop the activityIndicatorView from animating")
    }
    
    func testDisplayMovieReviews() {
        // Given
        let viewModel = MovieDetailsScene.LoadMovieReviews.ViewModel(alertControllerTitle: "Foo",
                                                                     alertControllerMessage: "Bar",
                                                                     alertControllerPreferredStyle: .actionSheet,
                                                                     actions: [(UIAlertAction(title: "★☆☆☆☆", style: .default), MovieReview.oneStar),
                                                                               (UIAlertAction(title: "★★☆☆☆", style: .default), MovieReview.twoStars)])
        
        // When
        loadView()
        sut.displayMovieReviews(viewModel: viewModel)
        
        // Then
        XCTAssertNotNil(sut.presentedViewController, "displayMovieReviews(viewModel:) should present an action sheet")
    }
    
    func testDisplayReviewMovie() {
        // Given
        loadView()
        
        sut.detailItems = [DetailItem.reviewMovie(review: "review")]
        
        let viewModel = MovieDetailsScene.ReviewMovie.ViewModel(reviewMovieItem: DetailItem.reviewMovie(review: "★★★★☆"))
        
        // When
        sut.displayReviewMovie(viewModel: viewModel)
        
        // Then
        guard let reviewMovieItem = sut.detailItems.first else {
            XCTFail("The first detailItem should not be nil")
            return
        }
        if case DetailItem.reviewMovie(let review) = reviewMovieItem {
            XCTAssertEqual(review, "★★★★☆", "displayReviewMovie(viewModel:) should set the reviewMovieItem")
        } else {
            XCTFail("The detailItem should be a reviewMovie item")
        }
    }
    
    func testDisplayFavoriteToggle() {
        // Given
        let viewModel = MovieDetailsScene.LoadFavoriteToggle.ViewModel(toggleFavoriteBarButtonItemTitle: "★")
        
        // When
        sut.displayFavoriteToggle(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.toggleFavoriteBarButtonItem.title, "★", "displayFavoriteToggle(viewModel:) should set the title of toggleFavoriteBarButtonItem")
    }

    func test_displayTableViewBackgroundView() {
        // Given
        loadView()

        let viewModel = MovieDetailsScene.LoadTableViewBackgroundView.ViewModel(backgroundView: nil)

        // When
        sut.displayTableViewBackgroundView(viewModel: viewModel)

        // Then
        XCTAssertNil(sut.detailItemsTableView.backgroundView, "displayTableViewBackgroundView(viewModel:) should update the backgroundView")
    }
    
    func testNumberOfRowsInSection0() {
        // Given
        loadView()
        sut.detailItems = DetailItem.dummyInstances
        
        // When
        let numberOfRowsInSection0 = sut.tableView(sut.detailItemsTableView, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRowsInSection0, 7)
    }
    
    func testCellForRowAtTitleItemIndexPath() {
        // Given
        loadView()
        sut.detailItems = DetailItem.dummyInstances
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        let cell = sut.tableView(sut.detailItemsTableView, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.textLabel?.text, "Whiplash")
    }
    
    func testCellForRowAtAdditionalInformationItemIndexPath() {
        // Given
        loadView()
        sut.detailItems = DetailItem.dummyInstances
        let indexPath = IndexPath(row: 1, section: 0)
        
        // When
        let cell = sut.tableView(sut.detailItemsTableView, cellForRowAt: indexPath)
        
        // Then
        guard let additionalInformationCell = cell as? AdditionalInformationTableViewCell else {
            XCTFail("The cell should be an instance of AdditionalInformationTableViewCell")
            return
        }
        XCTAssertNil(additionalInformationCell.posterImageView?.image)
        XCTAssertEqual(additionalInformationCell.releaseDateLabel?.attributedText?.string, "05/04/2019")
        XCTAssertEqual(additionalInformationCell.voteAverageLabel?.attributedText?.string, "★★★★☆")
    }
    
    func testCellForRowAtReviewMovieItemIndexPath() {
        // Given
        loadView()
        sut.detailItems = DetailItem.dummyInstances
        let indexPath = IndexPath(row: 2, section: 0)
        
        // When
        let cell = sut.tableView(sut.detailItemsTableView, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.detailTextLabel?.text, "review")
    }
    
    func testCellForRowAtTrailerItemIndexPath() {
        // Given
        loadView()
        sut.detailItems = DetailItem.dummyInstances
        let indexPath = IndexPath(row: 3, section: 0)
        
        // When
        let cell = sut.tableView(sut.detailItemsTableView, cellForRowAt: indexPath)
        
        // Then
        guard let trailerCell = cell as? TrailerTableViewCell else {
            XCTFail("The cell should be an instance of TrailerTableViewCell")
            return
        }
        XCTAssertNotNil(trailerCell.webView)
    }
    
    func testCellForRowAtSynopsisItemIndexPath() {
        // Given
        loadView()
        sut.detailItems = DetailItem.dummyInstances
        let indexPath = IndexPath(row: 4, section: 0)
        
        // When
        let cell = sut.tableView(sut.detailItemsTableView, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.detailTextLabel?.text, "masterpiece")
    }
    
    func testCellForRowAtCastingItemIndexPath() {
        // Given
        loadView()
        sut.detailItems = DetailItem.dummyInstances
        let indexPath = IndexPath(row: 5, section: 0)
        
        // When
        let cell = sut.tableView(sut.detailItemsTableView, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.detailTextLabel?.text, "John Doe, Zinedine Zidane")
    }
    
    func testCellForRowAtSimilarMoviesItemIndexPath() {
        // Given
        loadView()
        sut.detailItems = DetailItem.dummyInstances
        let indexPath = IndexPath(row: 6, section: 0)
        
        // When
        let cell = sut.tableView(sut.detailItemsTableView, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.detailTextLabel?.text, "Mo Better Blues, 8 Miles")
    }
    
    func testDidSelectRowAtReviewMovieItemIndexPath() {
        // Given
        let spy = MovieDetailsBusinessLogicSpy()
        sut.interactor = spy
        
        loadView()
        sut.detailItems = DetailItem.dummyInstances
        let indexPath = IndexPath(row: 2, section: 0)
        
        // When
        sut.tableView(sut.detailItemsTableView, didSelectRowAt: indexPath)
        
        // Then
        XCTAssertTrue(spy.loadMovieReviewsCalled, "selecting a reviewMovie item should ask the interactor to loadMovieReviews")
    }
}

extension DetailItem {
    
    static var dummyInstances: [DetailItem] {
        return [DetailItem.title(title: "Whiplash"),
                DetailItem.additionalInformation(posterImage: nil, releaseDate: "05/04/2019", voteAverage: "★★★★☆"),
                DetailItem.reviewMovie(review: "review"),
                DetailItem.trailer(urlRequest: URLRequest(url: URL(string: "https://www.youtube.com/embed/7TavVZMewpY")!)),
                DetailItem.synopsis(synopsis: "masterpiece"),
                DetailItem.casting(actors: "John Doe, Zinedine Zidane"),
                DetailItem.similarMovies(similarMovies: "Mo Better Blues, 8 Miles")]
    }
}
