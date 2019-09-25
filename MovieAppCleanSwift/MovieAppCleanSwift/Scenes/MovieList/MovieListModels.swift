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
      let flag: String
    }
    struct Response {
      let result: Result<[Movie], APIError>
    }
    struct ViewModel {
      struct MovieViewModel {
        let id: Int
        let title: String
        let popularity: Double
        let voteCount: Double
        var voteAverage: Double
        let backdropPath: String?
        let posterPath: String?
      }
      
      struct HandleError: Error {
        let errorMessage: String
      }
      
      let viewModel: Result<[MovieViewModel], HandleError>
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
  
}
