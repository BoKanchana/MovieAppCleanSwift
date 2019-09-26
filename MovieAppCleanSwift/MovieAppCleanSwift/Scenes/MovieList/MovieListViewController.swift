//
//  MovieListViewController.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 20/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

protocol MovieListViewControllerInterface: class {
  func displayMovies(viewModel: MovieList.GetMovie.ViewModel)
  func displayIdMovie(viewModel: MovieList.SetIdMovie.ViewModel)
  func displayUpdateVoteAverage(viewModel: MovieList.UpdateVoteAverage.ViewModel)
}

class MovieListViewController: UIViewController, MovieListViewControllerInterface {
  var interactor: MovieListInteractorInterface!
  var router: MovieListRouter!
  var movieViewModel: [MovieList.MovieViewModel] = []
  var flag: String = Flag.loadmore.rawValue
  var sort: String = Sort.desc.rawValue
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBAction func sortButton(_ sender: Any) {
    let optionMenu = UIAlertController(title: "Sort by relase date", message: "Choose Option", preferredStyle: .actionSheet)
    
    let ascending = UIAlertAction(title: "ASC", style: .default, handler: { _ in
      self.sort = Sort.asc.rawValue
      self.sortMovieList(sort: self.sort)
    })
    let descending = UIAlertAction(title: "DESC", style: .default, handler: { _ in
      self.sort = Sort.desc.rawValue
      self.sortMovieList(sort: self.sort)
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    optionMenu.addAction(descending)
    optionMenu.addAction(ascending)
    optionMenu.addAction(cancelAction)
    
    present(optionMenu, animated: true, completion: nil)
  }
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
    
    getMovies(sort: sort, flag: flag)
    pullToRefresh()
  }

  // MARK: - Event handling

  func getMovies(sort: String, flag: String) {
    let request = MovieList.GetMovie.Request(sort: sort, flag: flag)
    interactor.getMovies(request: request)
  }
  
  func sortMovieList(sort: String) {
    self.movieViewModel = []
    self.flag = Flag.refresh.rawValue
    self.getMovies(sort: sort, flag: self.flag)
  }
  
  func pullToRefresh() {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action:
      #selector(MovieListViewController.handleRefresh(_:)),
                             for: UIControl.Event.valueChanged)
    refreshControl.tintColor = UIColor.gray
    tableView.addSubview(refreshControl)
  }
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    let flag = Flag.refresh.rawValue
    getMovies(sort: sort, flag: flag)
    refreshControl.endRefreshing()
  }

  // MARK: - Display logic

  func displayMovies(viewModel: MovieList.GetMovie.ViewModel) {
    let result = viewModel.movies
    switch result {
    case .success(let listMovie):
      self.movieViewModel.append(contentsOf: listMovie)
      tableView.reloadData()
    case .failure(let error):
      displayHandleErrorAlert(error: error)
    }
  }
  
  func displayIdMovie(viewModel: MovieList.SetIdMovie.ViewModel) {
    router.navigateToMovieDetail()
  }
  
  func displayUpdateVoteAverage(viewModel: MovieList.UpdateVoteAverage.ViewModel) {
    for (index, value) in movieViewModel.enumerated() {
      if viewModel.movieCell.id == value.id {
        movieViewModel[index].voteAverage = viewModel.movieCell.voteAverage
      }
    }
    tableView.reloadData()
  }
  
  func displayHandleErrorAlert(error: Error) {
    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (action) in
      self.dismiss(animated: true, completion: nil)
    }))
    self.present(alert, animated: true)
  }

  // MARK: - Router

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == movieViewModel.count - 1 {
      flag = Flag.loadmore.rawValue
      getMovies(sort: sort, flag: flag)
    }
  }
}

extension MovieListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let request = MovieList.SetIdMovie.Request(id: movieViewModel[indexPath.row].id)
    interactor.setIdMovie(request: request)
  }
}

extension MovieListViewController: ReloadTable {
  func reloadTable(id: Int, voteAverage: Double) {
    let request = MovieList.UpdateVoteAverage.Request(id: id, voteAverage: voteAverage)
    interactor.updateVoteAverage(request: request)
    
    for (index, value) in movieViewModel.enumerated() {
      if id == value.id {
        movieViewModel[index].voteAverage = voteAverage
      }
    }
    tableView.reloadData()
  }
}
