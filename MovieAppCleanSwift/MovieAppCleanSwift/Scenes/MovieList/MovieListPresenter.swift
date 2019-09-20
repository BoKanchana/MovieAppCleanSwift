//
//  MovieListPresenter.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 20/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

protocol MovieListPresenterInterface {
  func presentMovieList(response: MovieList.GetMovie.Response)
}

class MovieListPresenter: MovieListPresenterInterface {
  weak var viewController: MovieListViewControllerInterface!

  // MARK: - Presentation logic
  
  func presentMovieList(response: MovieList.GetMovie.Response) {
    let movies = response.listMovies.results
    var moviesViewModel: [MovieList.GetMovie.ViewModel.MovieViewModel] = []
    for movie in movies {
      let id = movie.id
      let title = movie.title
      let popularity = movie.popularity
      let voteCount = movie.voteCount
      let avg = UserDefaults.standard.double(forKey: "\(movie.id)")
      let voteAverage: Double
      if avg == 0 {
        voteAverage = movie.voteAverage
      } else {
        let movieAverage = ((movie.voteCount * movie.voteAverage) + avg) / (movie.voteCount + 1)
        voteAverage = round(movieAverage)
      }
      let backdropPath = movie.backdropPath
      let posterPath = movie.posterPath
      let movieViewModel = MovieList.GetMovie.ViewModel.MovieViewModel(id: id, title: title, popularity: popularity, voteCount: voteCount, voteAverage: voteAverage, backdropPath: backdropPath, posterPath: posterPath)
      moviesViewModel.append(movieViewModel)
    }
    let viewModel = MovieList.GetMovie.ViewModel(movieViewModels: moviesViewModel)
    viewController.displayMovies(viewModel: viewModel)
  }
  
}
