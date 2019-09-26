//
//  MovieListTableViewCell.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 20/9/2562 BE.
//  Copyright © 2562 bobo. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListTableViewCell: UITableViewCell {
  @IBOutlet weak var backdropImage: UIImageView!
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var popularityLabel: UILabel!
  @IBOutlet weak var avgVoteLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setupUI(viewModel: MovieList.MovieViewModel) {
    let baseUrl: String = "https://image.tmdb.org/t/p/original"
    
    titleLabel.text = viewModel.title
    popularityLabel.text = "\(viewModel.popularity)"
    avgVoteLabel.text = "\(viewModel.voteAverage)"
    
    if let backdrop = viewModel.backdropPath {
      let urlBackdrop = URL(string: "\(baseUrl)\(backdrop)")
      backdropImage.kf.setImage(with: urlBackdrop)
    }
    
    if let poster = viewModel.posterPath {
      let urlPoster = URL(string: "\(baseUrl)\(poster)")
      posterImage.kf.setImage(with: urlPoster)
    }
    
  }
  
}
