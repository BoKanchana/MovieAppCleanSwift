//
//  MovieListWorker.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 20/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

protocol MovieListStoreProtocol {
  func getMovies(page: Int, sort: String,_ completion: @escaping (Result<ListMovie, APIError>) -> Void)
}

class MovieListWorker {

  var store: MovieListStoreProtocol

  init(store: MovieListStoreProtocol) {
    self.store = store
  }

  // MARK: - Business Logic
  
  func getMovies(page: Int, sort: String, _ completion: @escaping (Result<ListMovie, APIError>) -> Void) {
    store.getMovies(page: page, sort: sort) { result in
      completion(result)
    }
  }
  
}
