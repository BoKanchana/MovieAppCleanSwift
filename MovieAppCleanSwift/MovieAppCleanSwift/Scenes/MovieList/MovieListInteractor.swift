//
//  MovieListInteractor.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 20/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

protocol MovieListInteractorInterface {
  func getMovies(request: MovieList.GetMovie.Request)
  func setIdMovie(request: MovieList.SetIdMovie.Request)
  func updateVoteAverage(request: MovieList.UpdateVoteAverage.Request)
  var id: Int? { get }
}

class MovieListInteractor: MovieListInteractorInterface {
  
  var presenter: MovieListPresenterInterface!
  var worker: MovieListWorker?
  var movies: [Movie] = []
  var page: Int = 1
  var id: Int?
  

  // MARK: - Business logic

  func getMovies(request: MovieList.GetMovie.Request) {
    if request.flag == "refresh" {
      page = 1
    }
    
    worker?.getMovies(page: page, sort: request.sort) { result in
      switch result {
      case .success(let listMovie):
        self.movies = listMovie.results
        let response = MovieList.GetMovie.Response(result: .success(listMovie.results))
        self.presenter.presentMovieList(response: response)
        self.page += 1
        print("page: \(self.page)")
      case .failure(let error):
        let response = MovieList.GetMovie.Response(result: .failure(error))
        self.presenter.presentMovieList(response: response)
      }
    }
  }
  
  func setIdMovie(request: MovieList.SetIdMovie.Request) {
    id = request.id
    let resposne = MovieList.SetIdMovie.Response()
    presenter.setIdMovie(response: resposne)
  }
  
  func updateVoteAverage(request: MovieList.UpdateVoteAverage.Request) {
    let movieCell = movies.filter { (value) -> Bool in
      return value.id == request.id
    }
    if let movie = movieCell.first {
      let response = MovieList.UpdateVoteAverage.Response(movieCell: movie)
      presenter.updateVoteAverage(response: response)
    }
  }
  
}
