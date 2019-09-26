//
//  MovieListPresenterTests.swift
//  MovieAppCleanSwiftTests
//
//  Created by Kanchana Phakdeedorn on 25/9/2562 BE.
//  Copyright © 2562 bobo. All rights reserved.
//

@testable import MovieAppCleanSwift
import XCTest

class MovieListPresenterTests: XCTestCase {
  
  // MARK: - Subject Under Test
  
  var presenter: MovieListPresenter!
  var movieListPresenterOutputSpy: MovieListPresenterOutputSpy!
  
  // MARK: - Test lifecycle
  
  class MovieListPresenterOutputSpy: MovieListViewControllerInterface {
    var displayMovieCalled = false
    var displayIdMovieCalled = false
    var displayUpdateVoteAverageCalled = false
    var displayMovieViewModel: MovieList.GetMovie.ViewModel?
    var displayMovieViewModelSetIdMovie: MovieList.SetIdMovie.ViewModel?
    var displayMovieViewModelUpdateVoteAverage: MovieList.UpdateVoteAverage.ViewModel?
    
    func displayMovies(viewModel: MovieList.GetMovie.ViewModel) {
      displayMovieCalled = true
      displayMovieViewModel = viewModel
    }
    
    func displayIdMovie(viewModel: MovieList.SetIdMovie.ViewModel) {
      displayIdMovieCalled = true
      displayMovieViewModelSetIdMovie = viewModel
    }
    
    func displayUpdateVoteAverage(viewModel: MovieList.UpdateVoteAverage.ViewModel) {
      displayUpdateVoteAverageCalled = true
      displayMovieViewModelUpdateVoteAverage = viewModel
    }
  }
  
  override func setUp() {
    super.setUp()
    setupMovieListPresenter()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  // MARK: - Test setup
  
  func setupMovieListPresenter() {
    presenter = MovieListPresenter()
    movieListPresenterOutputSpy = MovieListPresenterOutputSpy()
  }
  
  // MARK: - Tests
  
  func testPresentMovieShouldAskViewControllerToDisplayMoviesWithSuccess() {
    // given
    presenter.viewController = movieListPresenterOutputSpy
    
    // when
    let movie = Movie(popularity: 2.0,
                      id: 123456,
                      video: false,
                      voteCount: 2.0,
                      voteAverage: 2.0,
                      title: "Test Movie",
                      releaseDate: "2019-01-01",
                      originalLanguage: "th",
                      originalTitle: "Test Movie",
                      genreIds: [1, 2, 3],
                      backdropPath: "/1234.jpg",
                      adult: false,
                      overview: "Test Movie",
                      posterPath: "/1234.jpg")
    let response = MovieList.GetMovie.Response(result: .success([movie]))
    presenter.presentMovieList(response: response)
    
    // then
    XCTAssert(movieListPresenterOutputSpy.displayMovieCalled)
    if let viewModel = movieListPresenterOutputSpy.displayMovieViewModel?.movies {
      switch viewModel {
      case .success(let movie):
        XCTAssertEqual(movie[0].id, 123456)
        XCTAssertEqual(movie[0].title, "Test Movie")
        XCTAssertEqual(movie[0].popularity, 2.0)
        XCTAssertEqual(movie[0].voteCount, 2.0)
        XCTAssertEqual(movie[0].voteAverage, 2.0)
        XCTAssertEqual(movie[0].backdropPath, "/1234.jpg")
        XCTAssertEqual(movie[0].posterPath, "/1234.jpg")
      default:
        XCTFail()
      }
    } else {
      XCTFail()
    }
  }
  
  func testPresentMovieShouldAskViewControllerToDisplayMoviesWithFailed() {
    // given
    presenter.viewController = movieListPresenterOutputSpy
    
    // when
    let response = MovieList.GetMovie.Response(result: .failure(.invalidData))
    presenter.presentMovieList(response: response)
    
    // then
    XCTAssert(movieListPresenterOutputSpy.displayMovieCalled)
    if let viewModel = movieListPresenterOutputSpy.displayMovieViewModel?.movies {
      switch viewModel {
      case .failure(let error):
        XCTAssertEqual(error, APIError.invalidData)
      default:
        XCTFail()
        
      }
    } else {
      XCTFail()
    }
  }
  
  func testSetIdMovieIsCalled() {
    // given
    presenter.viewController = movieListPresenterOutputSpy
    
    // when
    let response = MovieList.SetIdMovie.Response()
    presenter.setIdMovie(response: response)
    
    // then
    XCTAssert(movieListPresenterOutputSpy.displayIdMovieCalled, "Set id movie is called")
  }
  
  func testUpdateVoteAverageShouldcal() {
    // given
    presenter.viewController = movieListPresenterOutputSpy
    
    // when
    let cell = Movie(popularity: 2.0,
                     id: 123456,
                     video: true,
                     voteCount: 2.0,
                     voteAverage: 2.0,
                     title: "Test Movie",
                     releaseDate: "Test Movie",
                     originalLanguage: "Test Movie",
                     originalTitle: "Test Movie",
                     genreIds: [1, 2, 3],
                     backdropPath: "/test.jpg",
                     adult: true,
                     overview: "Test Movie",
                     posterPath: "/test.jpg")
    presenter.updateVoteAverage(response: MovieList.UpdateVoteAverage.Response(movieCell: cell))
    
    //Then
    XCTAssert(movieListPresenterOutputSpy.displayUpdateVoteAverageCalled)
    
    if let movieCell = movieListPresenterOutputSpy.displayMovieViewModelUpdateVoteAverage?.movieCell {
      XCTAssertEqual(movieCell.id, 123456)
      XCTAssertEqual(movieCell.popularity, 2.0)
      XCTAssertEqual(movieCell.voteCount, 2.0)
      XCTAssertEqual(movieCell.voteAverage, 2.0)
      XCTAssertEqual(movieCell.title, "Test Movie")
      XCTAssertEqual(movieCell.backdropPath, "/test.jpg")
      XCTAssertEqual(movieCell.posterPath, "/test.jpg")
    }
  }
}
