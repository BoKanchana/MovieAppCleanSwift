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
//  func presentErrorMessage(response: MovieList.GetMovie.Response.HandleError)
}

class MovieListPresenter: MovieListPresenterInterface {
  weak var viewController: MovieListViewControllerInterface!

  // MARK: - Presentation logic
  
  func presentMovieList(response: MovieList.GetMovie.Response) {
    let movies = response.result
    print("movies: \(movies)")
    var moviesViewModel: [MovieList.GetMovie.ViewModel.MovieViewModel] = []
    
    switch movies {
    case .success(let listMovie):
      listMovie.enumerated().map{ (index, movie) in
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
        let movieViewModel = MovieList.GetMovie.ViewModel.MovieViewModel(id: id,
                                                                         title: title,
                                                                         popularity: popularity,
                                                                         voteCount: voteCount,
                                                                         voteAverage: voteAverage,
                                                                         backdropPath: backdropPath,
                                                                         posterPath: posterPath)
        moviesViewModel.append(movieViewModel)
      }
      let viewModel = MovieList.GetMovie.ViewModel(viewModel: .success(moviesViewModel))
      viewController.displayMovies(viewModel: viewModel)
    case .failure(let error):
      let error = MovieList.GetMovie.ViewModel.HandleError(errorMessage: error.localizedDescription)
      let viewModel = MovieList.GetMovie.ViewModel(viewModel: .failure(error))
      viewController.displayMovies(viewModel: viewModel)
    }
    
//    for movie in movies {
//      let id = movie.id
//      let title = movie.title
//      let popularity = movie.popularity
//      let voteCount = movie.voteCount
//      let backdropPath = movie.backdropPath
//      let posterPath = movie.posterPath
//
//      let avg = UserDefaults.standard.double(forKey: "\(movie.id)")
//      let voteAverage: Double
//      if avg == 0 {
//        voteAverage = movie.voteAverage
//      } else {
//        let movieAverage = ((movie.voteCount * movie.voteAverage) + avg) / (movie.voteCount + 1)
//        let multiplier = pow(10.0, 2.0)
//        voteAverage = round(movieAverage * multiplier) / multiplier
//      }
//      let movieViewModel = MovieList.GetMovie.ViewModel.MovieViewModel(id: id,
//                                                                       title: title,
//                                                                       popularity: popularity,
//                                                                       voteCount: voteCount,
//                                                                       voteAverage: voteAverage,
//                                                                       backdropPath: backdropPath,
//                                                                       posterPath: posterPath)
//      moviesViewModel.append(movieViewModel)
//    }
//    let viewModel = MovieList.GetMovie.ViewModel(movieViewModels: moviesViewModel)
//    viewController.displayMovies(viewModel: viewModel)
  }
  
//  func presentErrorMessage(response: MovieList.GetMovie.Response.HandleError) {
//    let viewModel = MovieList.GetMovie.ViewModel.HandleError(errorMessage: response.errorMassage)
//    viewController.displayHandleErrorAlert(viewModel: viewModel)
//  }
  
  func setIdMovie(response: MovieList.SetIdMovie.Response) {
    let viewModel = MovieList.SetIdMovie.ViewModel()
    viewController.displayIdMovie(viewModel: viewModel)
  }
  
}
