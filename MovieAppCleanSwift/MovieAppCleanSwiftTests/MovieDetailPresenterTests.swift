//
//  MovieDetailPresenterTests.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 27/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

@testable import MovieAppCleanSwift
import XCTest

class MovieDetailPresenterTests: XCTestCase {

  // MARK: - Subject under test

  var presenter: MovieDetailPresenter!
  var movieDetailPresenterOutputSpy: MovieDetailPresenterOutputSpy!

  // MARK: - Test lifecycle
  
  class MovieDetailPresenterOutputSpy: MovieDetailViewControllerInterface {
    var delegate: ReloadTable?
    var displayMovieDetailCalled = false
    var displayUserVoingCalled = false
    var displayMovieDetailViewModel: MovieDetail.GetMovieDetail.ViewModel?
    var displayUserVotingViewModel: MovieDetail.SetUserVoting.ViewModel?
    
    func displayMovieDetail(viewModel: MovieDetail.GetMovieDetail.ViewModel) {
      displayMovieDetailCalled = true
      displayMovieDetailViewModel = viewModel
    }
    
    func displayUserVoting(viewModel: MovieDetail.SetUserVoting.ViewModel) {
      displayUserVoingCalled = true
      displayUserVotingViewModel = viewModel
    }
  }

  override func setUp() {
    super.setUp()
    setupMovieDetailPresenter()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: - Test setup

  func setupMovieDetailPresenter() {
    presenter = MovieDetailPresenter()
    movieDetailPresenterOutputSpy = MovieDetailPresenterOutputSpy()
  }
  
  // MARK: - Tests

  func testPresentMovieDetailShouldAskToDisplayMovieDetailWithSuccess() {
    // given
    presenter.viewController = movieDetailPresenterOutputSpy
    
    // when
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
    let response = MovieDetail.GetMovieDetail.Response(result: .success(movie))
    presenter.presentMovieDetail(response: response)
    
    // then
    XCTAssert(movieDetailPresenterOutputSpy.displayMovieDetailCalled)
    if let result = movieDetailPresenterOutputSpy.displayMovieDetailViewModel?.movie {
      switch result {
      case .success(let movie):
        XCTAssertEqual(movie.id, 1)
        XCTAssertEqual(movie.title, "Test")
        XCTAssertEqual(movie.overview, "Test")
        XCTAssertEqual(movie.originalLanguage, "")
        XCTAssertEqual(movie.posterPath, "/Test.jpg")
        XCTAssertEqual(movie.voteCount, 1)
        XCTAssertEqual(movie.voteAverageApi, 1)
        XCTAssertEqual(movie.collection, genre.name)
        XCTAssertEqual(movie.voteCount, 1)
      default:
        XCTFail()
      }
    }
  }
  
  func testPresentMovieDetailShouldAskToDisplayMovieDetailWithFail() {
    // given
    presenter.viewController = movieDetailPresenterOutputSpy
    
    // when
    let response = MovieDetail.GetMovieDetail.Response(result: .failure(.invalidData))
    presenter.presentMovieDetail(response: response)
    
    // then
    XCTAssert(movieDetailPresenterOutputSpy.displayMovieDetailCalled)
    if let result = movieDetailPresenterOutputSpy.displayMovieDetailViewModel?.movie {
      switch result {
      case .failure(let error):
        XCTAssertEqual(error, APIError.invalidData)
      default:
        XCTFail()
      }
    }
  }
  
  func testPresentUserVotingShouldAskToDisplayUserVoting() {
    // given
    presenter.viewController = movieDetailPresenterOutputSpy
    
    // when
    let response = MovieDetail.SetUserVoting.Response(id: 1, voteAverage: 1)
    presenter.presentUserVoting(response: response)
    
    // then
    XCTAssert(movieDetailPresenterOutputSpy.displayUserVoingCalled)
    XCTAssertEqual(movieDetailPresenterOutputSpy.displayUserVotingViewModel?.id, 1)
    XCTAssertEqual(movieDetailPresenterOutputSpy.displayUserVotingViewModel?.voteAverage, 1)
  }
  
}
