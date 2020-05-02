//
//  NowPlayingMoviesInteractorTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04.04.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Boxotop
import Box_Office_Movies_Core
import XCTest

//swiftlint:disable file_length
//swiftlint:disable type_body_length
final class NowPlayingMoviesInteractorTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: NowPlayingMoviesInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupNowPlayingMoviesInteractor()
    }

    override func tearDown() {
        super.tearDown()

        ManagerProvider.shared.favoritesManager.removeAllMovies()
    }
    
    // MARK: Test setup
    
    func setupNowPlayingMoviesInteractor() {
        sut = NowPlayingMoviesInteractor()
    }
    
    // MARK: Test doubles
    
    class NowPlayingMoviesPresentationLogicSpy: NowPlayingMoviesPresentationLogic {

        var presentNowPlayingMoviesExpectation = XCTestExpectation(description: "presentNowPlayingMovies called")
        var presentNowPlayingMoviesCalled = false
        var presentNextPageExpectation = XCTestExpectation(description: "presentNextPage called")
        var presentFilterMoviesCalled = false
        var presentRefreshMoviesExpectation = XCTestExpectation(description: "presentRefreshMovies called")
        var presentTableViewBackgroundViewCalled = false
        var presentFavoriteMoviesCalled = false
        var presentRefreshFavoriteMoviesCalled = false

        func presentNowPlayingMovies(response: NowPlayingMovies.FetchNowPlayingMovies.Response) {
            presentNowPlayingMoviesExpectation.fulfill()
            presentNowPlayingMoviesCalled = true
        }
        
        func presentNextPage(response: NowPlayingMovies.FetchNextPage.Response) {
            presentNextPageExpectation.fulfill()
        }
        
        func presentFilterMovies(response: NowPlayingMovies.FilterMovies.Response) {
            presentFilterMoviesCalled = true
        }
        
        func presentRefreshMovies(response: NowPlayingMovies.RefreshMovies.Response) {
            presentRefreshMoviesExpectation.fulfill()
        }
        
        func presentTableViewBackgroundView(response: NowPlayingMovies.LoadTableViewBackgroundView.Response) {
            presentTableViewBackgroundViewCalled = true
        }
        
        func presentFavoriteMovies(response: NowPlayingMovies.LoadFavoriteMovies.Response) {
            presentFavoriteMoviesCalled = true
        }

        func presentRefreshFavoriteMovies(response: NowPlayingMovies.RefreshFavoriteMovies.Response) {
            presentRefreshFavoriteMoviesCalled = true
        }
    }
    
    // MARK: Tests
    
    func testCurrentMoviesForAllMovies() {
        // Given
        sut.state = .allMovies
        
        // When
        let currentMovies = sut.currentMovies
        
        // Then
        XCTAssertEqual(currentMovies, sut.movies)
    }
    
    func testCurrentMoviesForFavorites() {
        // Given
        sut.state = .favorites
        
        // When
        let currentMovies = sut.currentMovies
        
        // Then
        XCTAssertEqual(currentMovies, sut.favoriteMovies)
    }
    
    func testFetchNowPlayingMoviesWithEmptyMovies() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy

        let request = NowPlayingMovies.FetchNowPlayingMovies.Request()
        
        // When
        sut.fetchNowPlayingMovies(request: request)
        
        // Then
        XCTAssertEqual(sut.state, .allMovies, "loadFavoriteMovies(request:) should set state")
        wait(for: [spy.presentNowPlayingMoviesExpectation], timeout: 0.1)
    }
    
    func testFetchNowPlayingMoviesWithNotEmptyMovies() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy

        let request = NowPlayingMovies.FetchNowPlayingMovies.Request()
        
        sut.movies = Movie.dummyInstances
        
        // When
        sut.fetchNowPlayingMovies(request: request)
        
        // Then
        XCTAssertEqual(sut.state, .allMovies, "loadFavoriteMovies(request:) should set state")
        XCTAssertTrue(spy.presentNowPlayingMoviesCalled, "fetchNowPlayingMovies(request:) should ask the presenter to format the result")
    }
    
    func testFilterMoviesWithEmptySearchText() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        sut.movies = Movie.dummyInstances
        let request = NowPlayingMovies.FilterMovies.Request(searchText: "", isSearchControllerActive: true)
        
        // When
        sut.filterMovies(request: request)
        
        // Then
        XCTAssertEqual(sut.filteredMovies, sut.currentMovies)
        XCTAssertTrue(spy.presentFilterMoviesCalled, "filterMovies(request:) should ask the presenter to format the result")
    }
    
    func testFilterMoviesWithSearchText() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        sut.movies = Movie.dummyInstances
        let request = NowPlayingMovies.FilterMovies.Request(searchText: "Wh", isSearchControllerActive: true)
        
        // When
        sut.filterMovies(request: request)
        
        // Then
        XCTAssertTrue(spy.presentFilterMoviesCalled, "filterMovies(request:) should ask the presenter to format the result")
    }
    
    func testRefreshMovies() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        let request = NowPlayingMovies.RefreshMovies.Request()
        
        // When
        sut.refreshMovies(request: request)
        
        // Then
        XCTAssertEqual(sut.state, .allMovies)
    }
    
    func testLoadFavoriteMovies() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        let request = NowPlayingMovies.LoadFavoriteMovies.Request(editButtonItem: UIBarButtonItem())
        
        // When
        sut.loadFavoriteMovies(request: request)
        
        // Then
        XCTAssertEqual(sut.state, .favorites, "loadFavoriteMovies(request:) should set state")
        XCTAssertTrue(spy.presentFavoriteMoviesCalled, "loadFavoriteMovies() should ask the presenter to format the result")
    }
    
    func testLoadTableViewBackgroundView() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        let request = NowPlayingMovies.LoadTableViewBackgroundView.Request(searchText: nil)
        
        // When
        sut.loadTableViewBackgroundView(request: request)
        
        // Then
        XCTAssertTrue(spy.presentTableViewBackgroundViewCalled, "loadTableViewBackgroundView(request:) should ask the presenter to format the result")
    }

    func test_refreshFavoriteMovies_withAllMoviesState_shouldRefreshPersistedData_andCallPresentRefreshFavoriteMovies() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy

        _ = ManagerProvider.shared.favoritesManager.addMovieToFavorites(Movie.dummyInstance)
        sut.favoriteMovies = ManagerProvider.shared.favoritesManager.favoriteMovies()

        sut.state = .allMovies

        let request = NowPlayingMovies.RefreshFavoriteMovies.Request(refreshSource: .movie(Movie.dummyInstance), editButtonItem: UIBarButtonItem(), searchText: nil, isSearchControllerActive: false)

        // When
        sut.refreshFavoriteMovies(request: request)

        // Then
        XCTAssertTrue(ManagerProvider.shared.favoritesManager.favoriteMovies()?.isEmpty == true, "refreshFavoriteMovies(request:) should refresh persisted data")
        XCTAssertTrue(spy.presentRefreshFavoriteMoviesCalled, "refreshFavoriteMovies(request:) should ask the presenter to format the result")
    }

    func test_refreshFavoriteMovies_withFavoritesState_movieRefreshShource_searchText_andActiveSearchController_shouldRefreshPersistedData_refreshMovieLists_andCallPresentRefreshFavoriteMovies() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy

        _ = ManagerProvider.shared.favoritesManager.addMovieToFavorites(Movie.dummyInstance)
        sut.favoriteMovies = ManagerProvider.shared.favoritesManager.favoriteMovies()
        sut.filteredMovies = ManagerProvider.shared.favoritesManager.favoriteMovies()

        sut.state = .favorites

        let request = NowPlayingMovies.RefreshFavoriteMovies.Request(refreshSource: .movie(Movie.dummyInstance), editButtonItem: UIBarButtonItem(), searchText: "W", isSearchControllerActive: true)

        // When
        sut.refreshFavoriteMovies(request: request)

        // Then
        XCTAssertTrue(ManagerProvider.shared.favoritesManager.favoriteMovies()?.isEmpty == true, "refreshFavoriteMovies(request:) should refresh persisted data")
        XCTAssertTrue(sut.favoriteMovies?.isEmpty == true, "refreshFavoriteMovies(request:) should refresh favoriteMovies")
        XCTAssertTrue(spy.presentRefreshFavoriteMoviesCalled, "refreshFavoriteMovies(request:) should ask the presenter to format the result")
    }

    func test_refreshPersistedData_withMovieToAddToFavoritesRefreshSource() {
        // Given
        let refreshSource = RefreshSource.movie(Movie.dummyInstance)

        // When
        sut.refreshPersistedData(with: refreshSource)

        // Then
        XCTAssertTrue(ManagerProvider.shared.favoritesManager.favoriteMovies()?.contains(where: { $0.identifier == 42 }) == true, "refreshPersistedData(with:) should refresh persisted data")
    }

    func test_refreshPersistedData_withMovieToRemoveFromFavoritesRefreshSource() {
        // Given
        _ = ManagerProvider.shared.favoritesManager.addMovieToFavorites(Movie.dummyInstance)
        let refreshSource = RefreshSource.movie(Movie.dummyInstance)

        // When
        sut.refreshPersistedData(with: refreshSource)

        // Then
        XCTAssertTrue(ManagerProvider.shared.favoritesManager.favoriteMovies()?.contains(where: { $0.identifier == 42 }) == false, "refreshPersistedData(with:) should refresh persisted data")
    }

    func test_refreshPersistedData_withIndexPathForMovieToRemoveRefreshSource() {
        // Given
        _ = ManagerProvider.shared.favoritesManager.addMovieToFavorites(Movie.dummyInstance)
        sut.favoriteMovies = ManagerProvider.shared.favoritesManager.favoriteMovies()

        let refreshSource = RefreshSource.indexPathForMovieToRemove(IndexPath(row: 0, section: 0))

        // When
        sut.refreshPersistedData(with: refreshSource)

        // Then
        XCTAssertTrue(ManagerProvider.shared.favoritesManager.favoriteMovies()?.contains(where: { $0.identifier == 42 }) == false, "refreshPersistedData(with:) should refresh persisted data")
    }

    func test_refreshMovieLists_withFavoritesState_movieToAddToFavoritesRefreshShource_shouldRefreshFavoriteMovies_andReturnAnInsertion() {
        // Given
        sut.state = .favorites
        sut.favoriteMovies = []

        let refreshSource = RefreshSource.movie(Movie.dummyInstance)

        // When
        let refreshType = sut.refreshMovieLists(with: refreshSource,
                                                isSearchControllerActive: false,
                                                searchText: nil)

        // Then
        XCTAssertTrue(sut.favoriteMovies?.isEmpty == false, "refreshMovieLists(with:isSearchControllerActive:searchText:) should refresh favoriteMovies")
        switch refreshType {
        case .deletion, .none:
            XCTFail("refreshMovieLists(with:isSearchControllerActive:searchText:) should return an .insertion")
        case .insertion(let insertionIndex):
            XCTAssertEqual(insertionIndex, 0, "refreshMovieLists(with:isSearchControllerActive:searchText:) should return an .insertion whose index is valid")
        }
    }

    func test_refreshMovieLists_withFavoritesState_movieToRemoveFromFavoritesRefreshShource_searchText_andActiveSearchController_shouldRefreshFavoriteMovies_refreshFilteredMovies_andReturnADeletion() {
        // Given
        _ = ManagerProvider.shared.favoritesManager.addMovieToFavorites(Movie.dummyInstance)
        sut.favoriteMovies = [Movie.dummyInstance]
        sut.filteredMovies = [Movie.dummyInstance]

        sut.state = .favorites

        let refreshSource = RefreshSource.movie(Movie.dummyInstance)
        let isSearchControllerActive = true
        let searchText = "W"

        // When
        let refreshType = sut.refreshMovieLists(with: refreshSource,
                                                isSearchControllerActive: isSearchControllerActive,
                                                searchText: searchText)

        // Then
        XCTAssertTrue(sut.favoriteMovies?.isEmpty == true, "refreshMovieLists(with:isSearchControllerActive:searchText:) should refresh favoriteMovies")
        XCTAssertTrue(sut.filteredMovies?.isEmpty == true, "refreshMovieLists(with:isSearchControllerActive:searchText:) should refresh filteredMovies")
        switch refreshType {
        case .insertion, .none:
            XCTFail("refreshMovieLists(with:isSearchControllerActive:searchText:) should return a .deletion")
        case .deletion(let deletionIndex):
            XCTAssertEqual(deletionIndex, 0, "refreshMovieLists(with:isSearchControllerActive:searchText:) should return a .deletion whose index is valid")
        }
    }

    func test_refreshMovieLists_withIndexPathForMovieToRemoveRefreshShource_shouldRefreshFavoriteMovies_andReturnADeletion() {
        // Given
        _ = ManagerProvider.shared.favoritesManager.addMovieToFavorites(Movie.dummyInstance)
        sut.favoriteMovies = ManagerProvider.shared.favoritesManager.favoriteMovies()

        let refreshSource = RefreshSource.indexPathForMovieToRemove(IndexPath(row: 0, section: 0))

        // When
        let refreshType = sut.refreshMovieLists(with: refreshSource,
                                                isSearchControllerActive: false,
                                                searchText: nil)

        // Then
        XCTAssertTrue(sut.favoriteMovies?.isEmpty == true, "refreshMovieLists(with:isSearchControllerActive:searchText:) should refresh favoriteMovies")
        switch refreshType {
        case .insertion, .none:
            XCTFail("refreshMovieLists(with:isSearchControllerActive:searchText:) should return a .deletion")
        case .deletion(let deletionIndex):
            XCTAssertEqual(deletionIndex, 0, "refreshMovieLists(with:isSearchControllerActive:searchText:) should return a .deletion whose index is valid")
        }
    }

    func test_removeMovie_shouldReturnADeletion() {
        // Given
        var movies: [Movie]? = Movie.dummyInstances
        let index = 0
        
        // When
        let refreshType = sut.removeMovieFrom(&movies, at: index)
        
        // Then
        switch refreshType {
        case .insertion, .none:
            XCTFail("removeMovieFrom(_:at:) should return a .deletion")
        case .deletion(let deletionIndex):
            XCTAssertEqual(deletionIndex, 0, "removeMovieFrom(_:at:) should return a .deletion whose index is valid")
        }
    }
    
    func test_appendMovie_shouldReturnAnInsertion() {
        // Given
        var movies: [Movie]? = Movie.dummyInstances

        // When
        let refreshType = sut.append(Movie.dummyInstance, to: &movies)
        
        // Then
        switch refreshType {
        case .deletion, .none:
            XCTFail("append(_:to:) should return an .insertion")
        case .insertion(let insertionIndex):
            XCTAssertEqual(insertionIndex, 2, "append(_:to:) should return an .insertion whose index is valid")
        }
    }

    func test_isFiltering_withInactiveSearchController_shouldReturnFalse() {
        // Given
        let isSearchControllerActive = false
        let searchText: String? = nil

        // When
        let isFiltering = sut.isFiltering(for: isSearchControllerActive, searchText: searchText)

        // Then
        XCTAssertFalse(isFiltering)
    }

    func test_isFiltering_withActiveSearchController_andNilSearchText_shouldReturnFalse() {
        // Given
        let isSearchControllerActive = true
        let searchText: String? = nil

        // When
        let isFiltering = sut.isFiltering(for: isSearchControllerActive, searchText: searchText)

        // Then
        XCTAssertFalse(isFiltering)
    }

    func test_isFiltering_withActiveSearchController_andSearchText_shouldReturnTrue() {
        // Given
        let isSearchControllerActive = true
        let searchText = "foo"

        // When
        let isFiltering = sut.isFiltering(for: isSearchControllerActive, searchText: searchText)

        // Then
        XCTAssertTrue(isFiltering)
    }
}

extension Movie {
    
    static var dummyInstance: Movie {
        return Movie(identifier: 42, title: "Whiplash")
    }
    
    static var dummyInstances: [Movie] {
        return [Movie(identifier: 42, title: "Whiplash"),
                Movie(identifier: 64, title: "Usual Suspects")]
    }
}

extension FavoritesManagement {

    func removeAllMovies() {
        favoriteMovies()?.forEach({ movie in
            _ = ManagerProvider.shared.favoritesManager.removeMovieFromFavorites(movie)
        })
    }
}
