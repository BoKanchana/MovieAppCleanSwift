//
//  MovieDetailPresenter.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 22/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

protocol MovieDetailPresenterInterface {
  func presentMovieDetail(response: MovieDetail.GetMovieDetail.Response)
  func presentUserVoting(response: MovieDetail.SetUserVoting.Response)
}

class MovieDetailPresenter: MovieDetailPresenterInterface {
  
  
  weak var viewController: MovieDetailViewControllerInterface!

  // MARK: - Presentation logic
  
  func presentMovieDetail(response: MovieDetail.GetMovieDetail.Response) {
    let movie = response.movieDetail
    
    let id = movie.id
    let title = movie.title
    let overview = movie.overview
    let originalLanguage = movie.originalLanguage ?? " - "
    let posterPath = movie.posterPath ??  " - "
    let voteCount = movie.voteCount
    let voteAverageApi = movie.voteAverage
    
    let voteAverage: Double
    let avg = UserDefaults.standard.double(forKey: "\(movie.id)")
    if avg == 0 {
      voteAverage = 0
    } else {
      voteAverage = avg / 2
    }
    
    var collection: [MovieDetail.GetMovieDetail.ViewModel.genreCollection] = []
    for genre in movie.genres {
      let name = genre.name
      let gen = MovieDetail.GetMovieDetail.ViewModel.genreCollection(name: name)
      collection.append(gen)
    }
    let viewModel = MovieDetail.GetMovieDetail.ViewModel(id: id,
                                                         title: title,
                                                         overview: overview,
                                                         originalLanguage: originalLanguage,
                                                         voteAverage: voteAverage,
                                                         collection: collection,
                                                         posterPath: posterPath,
                                                         voteCount: voteCount,
                                                         voteAverageApi: voteAverageApi)
    viewController.displayMovieDetail(viewModel: viewModel)
  }
  
  func presentUserVoting(response: MovieDetail.SetUserVoting.Response) {
    let viewModel = MovieDetail.SetUserVoting.ViewModel()
    viewController.displayUserVoting(viewModel: viewModel)
  }
  
}
