//
//  MovieDetailWorker.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 22/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

protocol MovieDetailStoreProtocol {
  func getMovieDetail(id: Int, _ completion: @escaping (Result<MovieDescription, APIError>) -> Void)
}

class MovieDetailWorker {

  var store: MovieDetailStoreProtocol

  init(store: MovieDetailStoreProtocol) {
    self.store = store
  }

  // MARK: - Business Logic

  func getMovieDetail(id: Int, _ completion: @escaping (Result<MovieDescription, APIError>) -> Void) {
    store.getMovieDetail(id: id) { result in
      completion(result)
    }
  }
}
