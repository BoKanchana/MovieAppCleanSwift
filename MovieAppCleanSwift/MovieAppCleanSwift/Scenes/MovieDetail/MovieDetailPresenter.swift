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
//  func presentHandleError(response: MovieDetail.GetMovieDetail.Response.HandleError)
}

class MovieDetailPresenter: MovieDetailPresenterInterface {
  
  
  weak var viewController: MovieDetailViewControllerInterface!

  // MARK: - Presentation logic
  
  func presentMovieDetail(response: MovieDetail.GetMovieDetail.Response) {
    switch response.result {
    case .success(let movie):
      let id = movie.id
      let title = movie.title
      let overview = movie.overview
      let originalLanguage = movie.originalLanguage ?? " - "
      let posterPath = movie.posterPath ??  " - "
      let voteCount = movie.voteCount
      let voteAverageApi = movie.voteAverage
      let collection = movie.genres.map { $0.name }.joined(separator: ", ")
      
      let voteAverage: Double
      let avg = UserDefaults.standard.double(forKey: "\(movie.id)")
      if avg == 0 {
        voteAverage = 0
      } else {
        voteAverage = avg / 2
      }
      let movieDetailViewModel = MovieDetail.MovieDetailViewModel(id: id,
                                                           title: title,
                                                           overview: overview,
                                                           originalLanguage: originalLanguage,
                                                           voteAverage: voteAverage,
                                                           collection: collection,
                                                           posterPath: posterPath,
                                                           voteCount: voteCount,
                                                           voteAverageApi: voteAverageApi)
      
      let viewModel = MovieDetail.GetMovieDetail.ViewModel(movie: .success(movieDetailViewModel))
      viewController.displayMovieDetail(viewModel: viewModel)
    case .failure(let error):
      let viewModel = MovieDetail.GetMovieDetail.ViewModel(movie: .failure(error))
      viewController.displayMovieDetail(viewModel: viewModel)
    }
  }
  
  func presentUserVoting(response: MovieDetail.SetUserVoting.Response) {
    let id = response.id
    let voteAverage = response.voteAverage
    let viewModel = MovieDetail.SetUserVoting.ViewModel(id: id, voteAverage: voteAverage)
    viewController.displayUserVoting(viewModel: viewModel)
  }
  
}
