//
//  MovieDetailsViewControllerTests.swift
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

class MovieDetailsViewControllerTests: XCTestCase {
    
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
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
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
        
        func fetchMovieDetails(request: MovieDetailsScene.FetchMovieDetails.Request) {
            fetchMovieDetailsCalled = true
        }
        
        func loadMovieReviews(request: MovieDetailsScene.LoadMovieReviews.Request) {
            loadMovieReviewsCalled = true
        }
        
        func reviewMovie(request: MovieDetailsScene.ReviewMovie.Request) {
            reviewMovieCalled = true
        }
    }
    
    // MARK: Tests
    
    func testInitWithNibNameAndBundle() {
        // When
        let movieDetailsViewController = MovieDetailsViewController(nibName: nil, bundle: nil)
        
        // Then
        XCTAssertNotNil(movieDetailsViewController, "init(nibName:, bundle:) should return an instance of MovieDetailsViewController")
    }
    
    func testFetchMovieDetailsWhenViewIsLoaded() {
        // Given
        let spy = MovieDetailsBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertTrue(spy.fetchMovieDetailsCalled, "viewDidLoad() should ask the interactor to fetchMovieDetails")
    }
    
    func testDisplayMovieDetails() {
        // Given
        let viewModel = MovieDetailsScene.FetchMovieDetails.ViewModel(detailItems: dummyDetailItems, shouldHideErrorView: true, errorDescription: nil)
        
        // When
        loadView()
        sut.displayMovieDetails(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.detailItems.count, 6, "displayMovieDetails(viewModel:) should append some detailItems to its detailItems")
        XCTAssertFalse(sut.activityIndicatorView.isAnimating, "displayMovieDetails(viewModel:) should stop the activityIndicatorView from animating")
        XCTAssertTrue(sut.errorStackView.isHidden, "displayMovieDetails(viewModel:) should set the isHidden property of the errorStackView")
        XCTAssertNil(sut.errorStackView.errorDescription, "displayMovieDetails(viewModel:) should set the errorDescription property of the errorStackView")
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
    
    func testNumberOfRowsInSection0() {
        // Given
        loadView()
        sut.detailItems = dummyDetailItems
        
        // When
        let numberOfRowsInSection0 = sut.tableView(sut.detailItemsTableView, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRowsInSection0, 6)
    }
    
    func testCellForRowAtTitleItemIndexPath() {
        // Given
        loadView()
        sut.detailItems = dummyDetailItems
        let indexPath = IndexPath(row: 0, section: 0)
        
        // When
        let cell = sut.tableView(sut.detailItemsTableView, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.textLabel?.text, "Whiplash")
    }
    
    func testCellForRowAtAdditionalInformationItemIndexPath() {
        // Given
        loadView()
        sut.detailItems = dummyDetailItems
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
        sut.detailItems = dummyDetailItems
        let indexPath = IndexPath(row: 2, section: 0)
        
        // When
        let cell = sut.tableView(sut.detailItemsTableView, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.detailTextLabel?.text, "review")
    }
    
    func testCellForRowAtSynopsisItemIndexPath() {
        // Given
        loadView()
        sut.detailItems = dummyDetailItems
        let indexPath = IndexPath(row: 3, section: 0)
        
        // When
        let cell = sut.tableView(sut.detailItemsTableView, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.detailTextLabel?.text, "masterpiece")
    }
    
    func testCellForRowAtCastingItemIndexPath() {
        // Given
        loadView()
        sut.detailItems = dummyDetailItems
        let indexPath = IndexPath(row: 4, section: 0)
        
        // When
        let cell = sut.tableView(sut.detailItemsTableView, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.detailTextLabel?.text, "John Doe, Zinedine Zidane")
    }
    
    func testCellForRowAtSimilarMoviesItemIndexPath() {
        // Given
        loadView()
        sut.detailItems = dummyDetailItems
        let indexPath = IndexPath(row: 5, section: 0)
        
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
        sut.detailItems = dummyDetailItems
        let indexPath = IndexPath(row: 2, section: 0)
        
        // When
        sut.tableView(sut.detailItemsTableView, didSelectRowAt: indexPath)
        
        // Then
        XCTAssertTrue(spy.loadMovieReviewsCalled, "selecting a reviewMovie item should ask the interactor to loadMovieReviews")
    }
}

extension MovieDetailsViewControllerTests {
    
    var dummyDetailItems: [DetailItem] {
        return [DetailItem.title(title: "Whiplash"),
                DetailItem.additionalInformation(posterImage: nil, releaseDateAttributedText: NSAttributedString(string: "05/04/2019"), voteAverageAttributedText: NSAttributedString(string: "★★★★☆")),
                DetailItem.reviewMovie(review: "review"),
                DetailItem.synopsis(synopsis: "masterpiece"),
                DetailItem.casting(actors: "John Doe, Zinedine Zidane"),
                DetailItem.similarMovies(similarMovies: "Mo Better Blues, 8 Miles")]
    }
}
