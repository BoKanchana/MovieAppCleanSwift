//
//  MovieListModels.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 20/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

struct MovieList {
  
  struct MovieViewModel {
    let id: Int
    let title: String
    let popularity: Double
    let voteCount: Double
    var voteAverage: Double
    let backdropPath: String?
    let posterPath: String?
  }
  
  struct GetMovie {
    struct Request {
      let sort: String
      let flag: String
    }
    struct Response {
      let result: Result<[Movie], APIError>
    }
    struct ViewModel {
      let movies: Result<[MovieViewModel], APIError>
    }
  }
  
  struct SetIdMovie {
    struct Request {
      let id: Int
    }
    struct Response {
      
    }
    struct ViewModel {
      
    }
  }
  
  struct UpdateVoteAverage {
    struct Request {
      let id: Int
      let voteAverage: Double
    }
    struct Response {
      let movieCell: Movie
    }
    struct ViewModel {
      let movieCell: MovieViewModel
    }
  }
}
