//
//  MovieDetailInteractor.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 22/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

protocol MovieDetailInteractorInterface {
  
}

class MovieDetailInteractor: MovieDetailInteractorInterface {
  var presenter: MovieDetailPresenterInterface!
  var worker: MovieDetailWorker?
  
  // MARK: - Business logic
  
  func doSomething(request: MovieDetail.Something.Request) {
    
  }
}
