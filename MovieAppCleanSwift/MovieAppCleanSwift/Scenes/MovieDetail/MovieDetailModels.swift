//
//  MovieDetailModels.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 22/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

struct MovieDetail {
  
  struct MovieDetailViewModel {
    var id: Int
    var title: String
    var overview: String
    var originalLanguage: String
    var voteAverage: Double
    var collection: String
    var posterPath: String
    var voteCount: Double
    var voteAverageApi: Double
  }
  
  struct GetMovieDetail {
    
    struct Request {
      
    }
    struct Response {
      let result: Result<MovieDescription, APIError>
    }
    struct ViewModel {
      let movie: Result<MovieDetailViewModel, APIError>
    }
  }
  
  struct SetUserVoting {
    struct Request {
      var id: Int
      var voting: Double
      var voteCount: Double
      var voteAverageApi: Double
    }
    struct Response {
      var id: Int
      var voteAverage: Double
    }
    struct ViewModel {
      var id: Int
      var voteAverage: Double
    }
  }
}
