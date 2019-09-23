//
//  MovieDetailViewController.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 22/9/2562 BE.
//  Copyright (c) 2562 bobo. All rights reserved.
//

import UIKit
import Cosmos

protocol MovieDetailViewControllerInterface: class {
  func displayMovieDetail(viewModel: MovieDetail.GetMovieDetail.ViewModel)
  func displayUserVoting(viewModel: MovieDetail.SetUserVoting.ViewModel)
}


class MovieDetailViewController: UIViewController, MovieDetailViewControllerInterface {
  
  var interactor: MovieDetailInteractorInterface!
  var router: MovieDetailRouter!
  var vote: Double?
  var movieDetailViewModel: MovieDetail.GetMovieDetail.ViewModel?
  let baseUrl: String = "https://image.tmdb.org/t/p/original"
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var languageLabel: UILabel!
  @IBOutlet weak var starVotingView: CosmosView!
  
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
    getMovieDetail()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    setVoting()
  }

  // MARK: - Event handling

  func getMovieDetail() {
    let request = MovieDetail.GetMovieDetail.Request()
    interactor.getMovieDetail(request: request)
  }
  
  func setVoting() {
    let id = movieDetailViewModel?.id
    let voteCount = movieDetailViewModel?.voteCount
    let voteAverageApi = movieDetailViewModel?.voteAverageApi
    if let id = id, let vote = vote, let voteCount = voteCount, let voteAverageApi = voteAverageApi {
      let request = MovieDetail.SetUserVoting.Request(id: id, voting: vote, voteCount: voteCount, voteAverageApi: voteAverageApi)
      self.interactor.setUserVoting(request: request)
    }
  }

  // MARK: - Display logic

  func displayMovieDetail(viewModel: MovieDetail.GetMovieDetail.ViewModel) {
    let posterPath = viewModel.posterPath
    let posterURL = URL(string: "\(baseUrl)\(posterPath)")
    posterImage.kf.setImage(with: posterURL)
    
    self.movieDetailViewModel = viewModel
    titleLabel.text = viewModel.title
    overviewLabel.text = viewModel.overview
    languageLabel.text = viewModel.originalLanguage
    
    var genres: String = ""
    for index in viewModel.collection {
      genres.append(contentsOf: "\(index.name) ")
    }
    genreLabel.text = genres
    starVotingView.rating = viewModel.voteAverage
    setStarforVoting()
  }
  
  func setStarforVoting() {
    starVotingView.settings.minTouchRating = 0
    starVotingView.settings.fillMode = .half
    starVotingView.settings.totalStars = 5
    
    starVotingView.didFinishTouchingCosmos = { rating in
      self.vote = rating * 2
    }
  }
  
  func displayUserVoting(viewModel: MovieDetail.SetUserVoting.ViewModel) {
    
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
