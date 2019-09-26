//
//  MovieListInteractorTests.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 25/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

@testable import MovieAppCleanSwift
import XCTest

class MovieListInteractorTests: XCTestCase {

  // MARK: - Subject under test

  var sut: MovieListInteractor!
  var movieListInteractorOutputSpy: MovieListInteractorOutputSpy!

  // MARK: - Test lifecycle
  
  class MovieListInteractorOutputSpy: MovieListPresenterInterface {
    func updateVoteAverage(response: MovieList.UpdateVoteAverage.Response) {
      
    }
    
    var presentMovieListCalled = false
    var presentSetIdMovieCalled = false
    
    func presentMovieList(response: MovieList.GetMovie.Response) {
      presentMovieListCalled = true
    }
    
    func setIdMovie(response: MovieList.SetIdMovie.Response) {
      presentSetIdMovieCalled = true
    }
    
  }

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
    setupMovieListInteractor()
  }

  // MARK: - Test setup

  func setupMovieListInteractor() {
    sut = MovieListInteractor()
    movieListInteractorOutputSpy = MovieListInteractorOutputSpy()
  }

  // MARK: - Test doubles

  // MARK: - Tests

  func testSomething() {
    // Given

    // When

    // Then
  }
}
