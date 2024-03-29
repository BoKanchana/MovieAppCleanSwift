//
//  MovieDetailInteractor.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 22/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

protocol MovieDetailInteractorInterface {
  func getMovieDetail(request: MovieDetail.GetMovieDetail.Request)
  func setUserVoting(request: MovieDetail.SetUserVoting.Request)
  var id: Int? { get set }
}

class MovieDetailInteractor: MovieDetailInteractorInterface {
  
  var presenter: MovieDetailPresenterInterface!
  var worker: MovieDetailWorker?
  var id: Int?
  
  // MARK: - Business logic
  
  func getMovieDetail(request: MovieDetail.GetMovieDetail.Request) {
    if let id = id {
      worker?.getMovieDetail(id: id) { [weak self] result in
        switch result {
        case .success(let movieDetail):
          let response = MovieDetail.GetMovieDetail.Response(result:.success(movieDetail) )
          self?.presenter.presentMovieDetail(response: response)
        case .failure(let error):
          let response = MovieDetail.GetMovieDetail.Response(result: .failure(error))
          self?.presenter.presentMovieDetail(response: response)
        }
      }
    }
  }
  
  func setUserVoting(request: MovieDetail.SetUserVoting.Request) {
    let voting = request.voting
    let id = request.id
    let voteCount = request.voteCount
    let voteAverageApi = request.voteAverageApi
    
    UserDefaults.standard.set(voting, forKey: "\(id)")
    
    let voteAverage = ((voteCount * voteAverageApi) + voting) / (voteCount + 1)
    let multiplier = 100.0
    let roundedVoteAverage = round(voteAverage * multiplier) / multiplier
    
    let response = MovieDetail.SetUserVoting.Response(id: id, voteAverage: roundedVoteAverage)
    presenter.presentUserVoting(response: response)
  }
  
}
