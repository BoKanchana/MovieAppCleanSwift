//
//  MovieListStore.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 20/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import Foundation

class MovieListStore: MovieListStoreProtocol {
  func getMovies(page: Int, sort: String, _ completion: @escaping (Result<ListMovie, APIError>) -> Void) {
    APIManager().getMoviesList(page: page, sort: sort) { (result) in
      DispatchQueue.main.sync {
        completion(result)
      }
    }
  }
  
}
