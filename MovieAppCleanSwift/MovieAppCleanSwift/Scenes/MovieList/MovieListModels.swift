//
//  MovieListModels.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 20/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

struct MovieList {
  
  struct GetMovie {
    struct Request {
      let sort: String
    }
    struct Response {
      let listMovies: ListMovie
    }
    struct ViewModel {
      struct MovieViewModel {
        let id: Int
        let title: String
        let popularity: Double
        let voteCount: Double
        let voteAverage: Double
        let backdropPath: String?
        let posterPath: String?
      }
      var movieViewModels: [MovieViewModel]
    }
  }
  
}
