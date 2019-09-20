//
//  MovieListViewController.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 20/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

enum Sort {
  case desc
  case asc
}

protocol MovieListViewControllerInterface: class {
  func displayMovies(viewModel: MovieList.GetMovie.ViewModel)
}

class MovieListViewController: UIViewController, MovieListViewControllerInterface {
  var interactor: MovieListInteractorInterface!
  var router: MovieListRouter!
  var movieViewModel: [MovieList.GetMovie.ViewModel.MovieViewModel] = []
  let sort: Sort = .desc
  
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Object lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    configure(viewController: self)
  }

  // MARK: - Configuration

  private func configure(viewController: MovieListViewController) {
    let router = MovieListRouter()
    router.viewController = viewController

    let presenter = MovieListPresenter()
    presenter.viewController = viewController

    let interactor = MovieListInteractor()
    interactor.presenter = presenter
    interactor.worker = MovieListWorker(store: MovieListStore())

    viewController.interactor = interactor
    viewController.router = router
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bundle = Bundle(for: MovieListTableViewCell.self)
    let nib = UINib(nibName: "MovieListTableViewCell", bundle: bundle)
    tableView.register(nib, forCellReuseIdentifier: "MovieListTableViewCell")
    
    getMovies(sort: sort)
  }

  // MARK: - Event handling

  func getMovies(sort: Sort) {
    let sortType: String
    
    switch sort {
    case .desc:
      sortType = "release_date.desc"
    case .asc:
      sortType = "release_date.asc"
    }
    
    let request = MovieList.GetMovie.Request(sort: sortType)
    interactor.getMovies(request: request)
  }

  // MARK: - Display logic

  func displayMovies(viewModel: MovieList.GetMovie.ViewModel) {
    movieViewModel.append(contentsOf: viewModel.movieViewModels)
    tableView.reloadData()
    print("movies list: \(movieViewModel.count)")
  }

  // MARK: - Router

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    router.passDataToNextScene(segue: segue)
  }

  @IBAction func unwindToMovieListViewController(from segue: UIStoryboardSegue) {
    print("unwind...")
    router.passDataToNextScene(segue: segue)
  }
}

extension MovieListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieViewModel.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell", for: indexPath) as? MovieListTableViewCell else {
      return UITableViewCell()
    }
    let viewModel = movieViewModel[indexPath.row]
    cell.setupUI(viewModel: viewModel)
    return cell
  }
}
