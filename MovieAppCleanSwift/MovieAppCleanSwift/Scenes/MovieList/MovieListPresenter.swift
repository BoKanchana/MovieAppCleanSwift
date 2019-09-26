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
  func setIdMovie(response: MovieList.SetIdMovie.Response)
  func updateVoteAverage(response: MovieList.UpdateVoteAverage.Response)
}

class MovieListPresenter: MovieListPresenterInterface {
  weak var viewController: MovieListViewControllerInterface!

  // MARK: - Presentation logic
  
  func presentMovieList(response: MovieList.GetMovie.Response) {
    let movies = response.result
    var moviesViewModel: [MovieList.MovieViewModel] = []
    
    switch movies {
    case .success(let listMovie):
      for movie in listMovie {
        let id = movie.id
        let title = movie.title
        let popularity = movie.popularity
        let voteCount = movie.voteCount
        let backdropPath = movie.backdropPath
        let posterPath = movie.posterPath
        
        let avg = UserDefaults.standard.double(forKey: "\(movie.id)")
        let voteAverage: Double
        if avg == 0 {
          voteAverage = movie.voteAverage
        } else {
          let movieAverage = ((movie.voteCount * movie.voteAverage) + avg) / (movie.voteCount + 1)
          let multiplier = pow(10.0, 2.0)
          voteAverage = round(movieAverage * multiplier) / multiplier
        }
        let movie = MovieList.MovieViewModel(id: id,
                                            title: title,
                                            popularity: popularity,
                                            voteCount: voteCount,
                                            voteAverage: voteAverage,
                                            backdropPath: backdropPath,
                                            posterPath: posterPath)
        moviesViewModel.append(movie)
      }
      let viewModel = MovieList.GetMovie.ViewModel(movies: .success(moviesViewModel))
      viewController.displayMovies(viewModel: viewModel)
    case .failure(let error):
      let viewModel = MovieList.GetMovie.ViewModel(movies: .failure(error))
      viewController.displayMovies(viewModel: viewModel)
    }
  }
  
  func setIdMovie(response: MovieList.SetIdMovie.Response) {
    let viewModel = MovieList.SetIdMovie.ViewModel()
    viewController.displayIdMovie(viewModel: viewModel)
  }
  
  func updateVoteAverage(response: MovieList.UpdateVoteAverage.Response) {
    let cell = response.movieCell
    let movie = MovieList.MovieViewModel(id: cell.id,
                                         title: cell.title,
                                         popularity: cell.popularity,
                                         voteCount: cell.voteCount,
                                         voteAverage: cell.voteAverage,
                                         backdropPath: cell.backdropPath,
                                         posterPath: cell.posterPath)
    let viewModel = MovieList.UpdateVoteAverage.ViewModel(movieCell: movie)
    viewController.displayUpdateVoteAverage(viewModel: viewModel)
  }

}
