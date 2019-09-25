//
//  MovieDetailModels.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 22/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

struct MovieDetail {
  
  struct GetMovieDetail {
    
    struct Request {
      
    }
    struct Response {
      var movieDetail: MovieDescription
      struct HandleError {
        var error: String
      }
    }
    struct ViewModel {
      var id: Int
      var title: String
      var overview: String
      var originalLanguage: String
      var voteAverage: Double
      var collection: String
      var posterPath: String
      var voteCount: Double
      var voteAverageApi: Double
      
      struct HandleError {
        var errorMessage: String
      }
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
      
    }
    struct ViewModel {
      
    }
  }
}
