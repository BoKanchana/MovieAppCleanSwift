//
//  MovieDetailStore.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 22/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import Foundation

class MovieDetailStore: MovieDetailStoreProtocol {
  func getMovieDetail(id: Int, _ completion: @escaping (Result<MovieDescription, APIError>) -> Void) {
    APIManager().getMovieDetail(id: id) { (result) in
      DispatchQueue.main.sync {
        completion(result)
      }
    }
  }
}
