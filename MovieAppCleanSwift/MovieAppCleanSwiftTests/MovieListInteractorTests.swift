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
  
  var interactor: MovieListInteractor!
  var movieListWorkerOutputSpy: MovieListWorkerOutputSpy!
  var movieListInteractorOutputSpy: MovieListInteractorOutputSpy!
  
  // MARK: - Test lifecycle
  
  class MovieListInteractorOutputSpy: MovieListPresenterInterface {
    var presentMovieListCalled = false
    var presentSetIdMovieCalled = false
    var presentUpdateVoteAverageCalled = false
    var presentMovieListResponse: MovieList.GetMovie.Response?
    var presentSetIdMovieResponse: MovieList.SetIdMovie.Response?
    var presentUpdateVoteAverageResponse: MovieList.UpdateVoteAverage.Response?
    
    func presentMovieList(response: MovieList.GetMovie.Response) {
      presentMovieListCalled = true
      presentMovieListResponse = response
    }
    
    func setIdMovie(response: MovieList.SetIdMovie.Response) {
      presentSetIdMovieCalled = true
      presentSetIdMovieResponse = response
    }
    
    func updateVoteAverage(response: MovieList.UpdateVoteAverage.Response) {
      presentUpdateVoteAverageCalled = true
      presentUpdateVoteAverageResponse = response
    }
    
  }
  
  class MovieListWorkerOutputSpy: MovieListWorker {
    var workerGetMoviesCalled = false
    var isSuccess = false
    var workerGetMoviesSuccessCalled = false
    var workerGetMoviesFailCalled = false
    
    override func getMovies(page: Int, sort: String, _ completion: @escaping (Result<ListMovie, APIError>) -> Void) {
      workerGetMoviesCalled = true
      if isSuccess {
        
        let movie = Movie(popularity: 0,
                          id: 0,
                          video: true,
                          voteCount: 0,
                          voteAverage: 0,
                          title: "Test",
                          releaseDate: "Test",
                          originalLanguage: "Test",
                          originalTitle: "Test",
                          genreIds: [1, 2, 3],
                          backdropPath: "/Test.jpg",
                          adult: true,
                          overview: "Test",
                          posterPath: "/Test.jpg")
        completion(Result<ListMovie, APIError>.success(ListMovie(page: 1,
                                                                 totalResults: 10000,
                                                                 totalPages: 500,
                                                                 results: [movie])))
        workerGetMoviesSuccessCalled = true
      } else {
        completion(Result<ListMovie, APIError>.failure(.invalidData))
        workerGetMoviesFailCalled = true
      }
    }
  }
  
  override func setUp() {
    super.setUp()
    setupMovieListInteractor()
    interactor.presenter = movieListInteractorOutputSpy
    interactor.worker = movieListWorkerOutputSpy
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupMovieListInteractor() {
    interactor = MovieListInteractor()
    movieListInteractorOutputSpy = MovieListInteractorOutputSpy()
    movieListWorkerOutputSpy = MovieListWorkerOutputSpy(store: MovieListStore())
  }
  
  // MARK: - Tests
  
  func testGetMoviesWithFlagLoadMoreShouldAskPresenterToPresentMoviesWithSuccess() {
    // given
    movieListWorkerOutputSpy.isSuccess = true
    let request = MovieList.GetMovie.Request(sort: "release_date.desc", flag: "loadmore")
    
    // when
    interactor.getMovies(request: request)
    
    // then
    XCTAssert(movieListInteractorOutputSpy.presentMovieListCalled)
    XCTAssert(movieListWorkerOutputSpy.workerGetMoviesCalled)
    XCTAssert(movieListWorkerOutputSpy.workerGetMoviesSuccessCalled)
  }
  
  func testGetMoviesWithFlagLoadMoreShouldAskPresenterToPresentMoviesWithFail() {
    // given
    let request = MovieList.GetMovie.Request(sort: "release_date.desc", flag: "loadmore")
    
    // when
    interactor.getMovies(request: request)
    
    // then
    XCTAssert(movieListInteractorOutputSpy.presentMovieListCalled)
    XCTAssert(movieListWorkerOutputSpy.workerGetMoviesCalled)
    XCTAssert(movieListWorkerOutputSpy.workerGetMoviesFailCalled)
  }
  
  func testGetMoviesWithFlagRefreshShouldAskPresenterToPresentMoviesWithSuccess() {
    // given
    let request = MovieList.GetMovie.Request(sort: "release_date.desc", flag: "refresh")
    
    // when
    interactor.getMovies(request: request)
    
    // then
    XCTAssert(movieListInteractorOutputSpy.presentMovieListCalled)
    XCTAssert(movieListWorkerOutputSpy.workerGetMoviesCalled)
  }
  
  func testGetMoviesWithSortAcescendingShouldAskPresenterToPresentMoviesWithSuccess() {
    // given
    let request = MovieList.GetMovie.Request(sort: "release_date.desc", flag: "loadmore")
    
    // when
    interactor.getMovies(request: request)
    
    //
  }
  
  func testSetIdMovieIsCalled() {
    // given
    interactor.presenter = movieListInteractorOutputSpy
    
    // when
    let request = MovieList.SetIdMovie.Request(id: 1)
    interactor.setIdMovie(request: request)
    
    // then
    XCTAssert(movieListInteractorOutputSpy.presentSetIdMovieCalled)
  }
  
  func testUpdateVoteAverage() {
    // given
    interactor.movies = [Movie(popularity: 1,
                               id: 1,
                               video: true,
                               voteCount: 1,
                               voteAverage: 1,
                               title: "Test",
                               releaseDate: "Test",
                               originalLanguage: "Test",
                               originalTitle: "Test",
                               genreIds: [1, 2, 3],
                               backdropPath: "/Test.jpg",
                               adult: true,
                               overview: "Test",
                               posterPath: "/Test.jpg")]
    
    // when
    let request = MovieList.UpdateVoteAverage.Request(id: 1, voteAverage: 1)
    interactor.updateVoteAverage(request: request)
    
    // then
    XCTAssert(movieListInteractorOutputSpy.presentUpdateVoteAverageCalled)
  }
  
}
