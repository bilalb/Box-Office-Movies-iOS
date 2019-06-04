//
//  MovieDetailsInteractorTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04.04.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Box_Office_Movies
import Box_Office_Movies_Core
import CoreData
import XCTest

class MovieDetailsInteractorTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: MovieDetailsInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMovieDetailsInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            XCTFail("appDelegate should be an instance of AppDelegate")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: FavoriteMovie.entityName)
        
        do {
            if let favoriteMovies = try managedContext.fetch(fetchRequest) as? [FavoriteMovie],
                let favoriteMovieToDelete = favoriteMovies.first(where: { $0.identifier == MovieDetails.dummyInstance.identifier }) {
                managedContext.delete(favoriteMovieToDelete)
                try managedContext.save()
            }
        } catch let error as NSError {
            XCTFail("A Core Data error occured. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Test setup
    
    func setupMovieDetailsInteractor() {
        sut = MovieDetailsInteractor()
    }
    
    // MARK: Test doubles
    
    class MovieDetailsPresentationLogicSpy: MovieDetailsPresentationLogic {
        
        var presentMovieDetailsExpectation = XCTestExpectation(description: "presentMovieDetails called")
        var presentMovieReviewsCalled = false
        var presentReviewMovieCalled = false

        func presentMovieDetails(response: MovieDetailsScene.FetchMovieDetails.Response) {
            presentMovieDetailsExpectation.fulfill()
        }
        
        func presentMovieReviews(response: MovieDetailsScene.LoadMovieReviews.Response) {
            XCTAssertEqual(response.movieReviews.count, 5)
            
            presentMovieReviewsCalled = true
        }
        
        func presentReviewMovie(response: MovieDetailsScene.ReviewMovie.Response) {
            XCTAssertEqual(response.movieReview.description, "★★★★☆")
            
            presentReviewMovieCalled = true
        }
    }
    
    // MARK: Tests
    
    func testLoadMovieReviews() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        let request = MovieDetailsScene.LoadMovieReviews.Request()
        
        // When
        sut.loadMovieReviews(request: request)
        
        // Then
        XCTAssertTrue(spy.presentMovieReviewsCalled, "loadMovieReviews(request:) should ask the presenter to format the result")
    }
    
    func testReviewMovie() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        let request = MovieDetailsScene.ReviewMovie.Request(movieReview: MovieReview.fourStars)
        
        // When
        sut.reviewMovie(request: request)
        
        // Then
        XCTAssertTrue(spy.presentReviewMovieCalled, "reviewMovie(request:) should ask the presenter to format the result")
    }
    
    func testAddMovieToFavorites() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        
        sut.movieDetails = MovieDetails.dummyInstance
        
        let request = MovieDetailsScene.AddMovieToFavorites.Request()
        
        // When
        sut.addMovieToFavorites(request: request)
        
        // Then
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            XCTFail("appDelegate should be an instance of AppDelegate")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: FavoriteMovie.entityName)
        
        do {
            if let favoriteMovies = try managedContext.fetch(fetchRequest) as? [FavoriteMovie] {
                XCTAssertTrue(favoriteMovies.contains(where: { $0.identifier == 0 }))
            }
        } catch let error as NSError {
            XCTFail("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension MovieDetails {
    
    static var dummyInstance: MovieDetails {
        return MovieDetails(identifier: 0, title: "foo", releaseDate: "12345", voteAverage: 1, synopsis: "bar", posterPath: "a")
    }
}
