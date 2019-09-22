//
//  MovieListRouter.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 20/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

protocol MovieListRouterInput {
  func navigateToMovieDetail()
}

class MovieListRouter: MovieListRouterInput {
  weak var viewController: MovieListViewController!

  // MARK: - Navigation

  func navigateToMovieDetail() {
    viewController.performSegue(withIdentifier: "showMovieDetail", sender: nil)
  }

  // MARK: - Communication

  func passDataToNextScene(segue: UIStoryboardSegue) {

    if segue.identifier == "showMovieDetail" {
      passDataToSomewhereScene(segue: segue)
    }
  }

  func passDataToSomewhereScene(segue: UIStoryboardSegue) {
    // NOTE: Teach the router how to pass data to the next scene
    guard let movieDetailViewController = segue.destination as? MovieDetailViewController, let id = viewController.interactor.id else {
      return
    }
    
    movieDetailViewController.interactor.id = viewController.interactor.id

    // let someWhereViewController = segue.destinationViewController as! SomeWhereViewController
    // someWhereViewController.interactor.model = viewController.interactor.model
  }
}
