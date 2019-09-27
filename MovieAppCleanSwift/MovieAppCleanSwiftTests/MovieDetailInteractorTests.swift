//
//  MovieDetailInteractorTests.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 27/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

@testable import MovieAppCleanSwift
import XCTest

class MovieDetailInteractorTests: XCTestCase {

  // MARK: - Subject under test

  var interactor: MovieDetailInteractor!
  var movieDetailWorkerOutputSpy: MovieDetailWorkerOutputSpy!
  var movieDetailInteractorOutputSpy: MovieDetailInteractorOutputSpy!

  // MARK: - Test lifecycle
  
  class MovieDetailInteractorOutputSpy: MovieDetailPresenterInterface {
    var presenterMovieDetailCalled = false
    var presenterUserVotingCalled = false
    var presenterMovieDetailResponse: MovieDetail.GetMovieDetail.Response?
    var presenterUserVotingResponse: MovieDetail.SetUserVoting.Response?
    
    func presentMovieDetail(response: MovieDetail.GetMovieDetail.Response) {
      presenterMovieDetailCalled = true
      presenterMovieDetailResponse = response
    }
    
    func presentUserVoting(response: MovieDetail.SetUserVoting.Response) {
      presenterUserVotingCalled = true
      presenterUserVotingResponse = response
    }
  }
  
  class MovieDetailWorkerOutputSpy: MovieDetailWorker {
    var workerGetMovieDetailCalled = false
    var isSuccess = true
    
    override func getMovieDetail(id: Int, _ completion: @escaping (Result<MovieDescription, APIError>) -> Void) {
      workerGetMovieDetailCalled = true
      if isSuccess {
        let genre = genres(id: 1, name: "Test")
        let movie = MovieDescription(adult: true,
                                     backdropPath: "/Test.jpg",
                                     belongsToCollection: "Test",
                                     budget: 1,
                                     genres: [genre],
                                     homepage: "Test",
                                     id: 1,
                                     imdbId: "Test",
                                     originalLanguage: "",
                                     originalTitle: "Test",
                                     overview: "Test",
                                     popularity: 1,
                                     posterPath: "/Test.jpg",
                                     releaseDate: "Test",
                                     revenue: 1,
                                     status: "Test",
                                     title: "Test",
                                     voteCount: 1,
                                     voteAverage: 1)
        completion(.success(movie))
      } else {
        completion(.failure(.invalidData))
      }
    }
  }

  override func setUp() {
    super.setUp()
    setupMovieDetailInteractor()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: - Test setup

  func setupMovieDetailInteractor() {
    interactor = MovieDetailInteractor()
    movieDetailWorkerOutputSpy = MovieDetailWorkerOutputSpy(store: MovieDetailStore())
    movieDetailInteractorOutputSpy = MovieDetailInteractorOutputSpy()
  }

  // MARK: - Tests

  func testGetMovieDetailShouldAskToPresentMovieDetailWithSuccess() {
    // given
    interactor.presenter = movieDetailInteractorOutputSpy
    interactor.worker = movieDetailWorkerOutputSpy
    interactor.id = 1
    
    // when
    let request = MovieDetail.GetMovieDetail.Request()
    interactor.getMovieDetail(request: request)
    
    // then
    XCTAssert(movieDetailWorkerOutputSpy.workerGetMovieDetailCalled)
    XCTAssert(movieDetailInteractorOutputSpy.presenterMovieDetailCalled)
  }
  
  func testGetMovieDetailShouldAskToPresentMovieDetailWithFail() {
    // given
    interactor.presenter = movieDetailInteractorOutputSpy
    interactor.worker = movieDetailWorkerOutputSpy
    interactor.id = 1
    movieDetailWorkerOutputSpy.isSuccess = false
    
    // when
    let request = MovieDetail.GetMovieDetail.Request()
    interactor.getMovieDetail(request: request)
    
    // then
    XCTAssert(movieDetailWorkerOutputSpy.workerGetMovieDetailCalled)
    XCTAssert(movieDetailInteractorOutputSpy.presenterMovieDetailCalled)
  }
  
  func testSetuserVotingShouldAskPresentUserVoting() {
    // given
    interactor.presenter = movieDetailInteractorOutputSpy
    
    // when
    let request = MovieDetail.SetUserVoting.Request(id: 1, voting: 1, voteCount: 1, voteAverageApi: 1)
    interactor.setUserVoting(request: request)
    
    // then
    XCTAssert(movieDetailInteractorOutputSpy.presenterUserVotingCalled)
    XCTAssertEqual(movieDetailInteractorOutputSpy.presenterUserVotingResponse?.id, 1)
    XCTAssertEqual(movieDetailInteractorOutputSpy.presenterUserVotingResponse?.voteAverage, 1)
  }
  
}
