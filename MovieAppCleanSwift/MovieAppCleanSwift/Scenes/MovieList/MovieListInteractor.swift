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
  var listMovie: ListMovie? { get }
  var error: String { get }
}

class MovieListInteractor: MovieListInteractorInterface {
  var presenter: MovieListPresenterInterface!
  var worker: MovieListWorker?
  var listMovie: ListMovie?
  var error: String = ""
  var page: Int = 1
  

  // MARK: - Business logic

  func getMovies(request: MovieList.GetMovie.Request) {
    worker?.getMovies(page: page, sort: request.sort) { result in
      switch result {
      case .success(let listMovie):
        self.listMovie = listMovie
        let response = MovieList.GetMovie.Response(listMovies: listMovie)
        self.presenter.presentMovieList(response: response)
      case .failure(let error):
        self.error = error.localizedDescription
      }
    }
  }
  
}
