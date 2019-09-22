//
//  MovieListViewController.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 20/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit

enum Sort: String {
  case desc = "release_date.desc"
  case asc = "release_date.asc"
}

enum Flag: String {
  case refresh
  case loadmore
}

protocol MovieListViewControllerInterface: class {
  func displayMovies(viewModel: MovieList.GetMovie.ViewModel)
}

class MovieListViewController: UIViewController, MovieListViewControllerInterface {
  var interactor: MovieListInteractorInterface!
  var router: MovieListRouter!
  var movieViewModel: [MovieList.GetMovie.ViewModel.MovieViewModel] = []
  var flag: String = Flag.loadmore.rawValue
  var sort: String = Sort.desc.rawValue
  
  @IBOutlet weak var tableView: UITableView!
  
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action:
      #selector(MovieListViewController.handleRefresh(_:)),
                             for: UIControl.Event.valueChanged)
    refreshControl.tintColor = UIColor.gray
    
    return refreshControl
  }()
  
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
    
    self.present(optionMenu, animated: true, completion: nil)
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
  }

  // MARK: - Event handling

  func getMovies(sort: String, flag: String) {
    let request = MovieList.GetMovie.Request(sort: sort, flag: flag)
    interactor.getMovies(request: request)
  }
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    let flag = Flag.refresh.rawValue
    getMovies(sort: sort, flag: flag)
    refreshControl.endRefreshing()
  }
  
  func sortMovieList(sort: String) {
    self.movieViewModel = []
    self.flag = Flag.refresh.rawValue
    self.getMovies(sort: sort, flag: self.flag)
  }

  // MARK: - Display logic

  func displayMovies(viewModel: MovieList.GetMovie.ViewModel) {
    movieViewModel.append(contentsOf: viewModel.movieViewModels)
    tableView.reloadData()
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
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == movieViewModel.count - 1 {
      flag = Flag.loadmore.rawValue
      getMovies(sort: sort, flag: flag)
    }
  }
}

extension MovieListViewController: UITableViewDelegate {
  override func viewWillAppear(_ animated: Bool) {
    self.tableView.reloadData()
  }
}
