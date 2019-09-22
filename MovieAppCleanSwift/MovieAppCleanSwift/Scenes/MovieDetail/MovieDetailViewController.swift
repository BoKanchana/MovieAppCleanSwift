//
//  MovieDetailViewController.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 22/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

protocol MovieDetailViewControllerInterface: class {
  func displaySomething(viewModel: MovieDetail.Something.ViewModel)
}

class MovieDetailViewController: UIViewController, MovieDetailViewControllerInterface {
  var interactor: MovieDetailInteractorInterface!
  var router: MovieDetailRouter!

  // MARK: - Object lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    configure(viewController: self)
  }

  // MARK: - Configuration

  private func configure(viewController: MovieDetailViewController) {
    let router = MovieDetailRouter()
    router.viewController = viewController

    let presenter = MovieDetailPresenter()
    presenter.viewController = viewController

    let interactor = MovieDetailInteractor()
    interactor.presenter = presenter
    interactor.worker = MovieDetailWorker(store: MovieDetailStore())

    viewController.interactor = interactor
    viewController.router = router
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  // MARK: - Event handling

  func doSomethingOnLoad() {
    // NOTE: Ask the Interactor to do some work

    let request = MovieDetail.Something.Request()
  }

  // MARK: - Display logic

  func displaySomething(viewModel: MovieDetail.Something.ViewModel) {
    // NOTE: Display the result from the Presenter

    // nameTextField.text = viewModel.name
  }

  // MARK: - Router

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    router.passDataToNextScene(segue: segue)
  }

  @IBAction func unwindToMovieDetailViewController(from segue: UIStoryboardSegue) {
    print("unwind...")
    router.passDataToNextScene(segue: segue)
  }
}
