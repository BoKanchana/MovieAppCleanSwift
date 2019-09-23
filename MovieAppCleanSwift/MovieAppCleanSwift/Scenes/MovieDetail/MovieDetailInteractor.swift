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
  var delegate: ReloadTable? { get set }
  var id: Int? { get set }
}

protocol ReloadTable: class {
  func reloadTable(id: Int, voteAverage: Double)
}

class MovieDetailInteractor: MovieDetailInteractorInterface {
  
  var presenter: MovieDetailPresenterInterface!
  var worker: MovieDetailWorker?
  var delegate: ReloadTable?
  var id: Int?
  
  // MARK: - Business logic
  
  func getMovieDetail(request: MovieDetail.GetMovieDetail.Request) {
    if let id = id {
      worker?.getMovieDetail(id: id) { [weak self] result in
        switch result {
        case .success(let movieDetail):
          
          let response = MovieDetail.GetMovieDetail.Response(movieDetail: movieDetail)
          self?.presenter.presentMovieDetail(response: response)
        case .failure(let error):
          print("error: \(error)")
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
    delegate?.reloadTable(id: id, voteAverage: voteAverage)
    
    let response = MovieDetail.SetUserVoting.Response(id: id, voteAverage: voteAverage)
    presenter.presentUserVoting(response: response)
  }
  
}