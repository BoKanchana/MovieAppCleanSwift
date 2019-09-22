//
//  Movie.swift
//  MovieAppCleanSwift
//
//  Created by Kanchana Phakdeedorn on 20/9/2562 BE.
//  Copyright © 2562 bobo. All rights reserved.
//

import Foundation

struct ListMovie: Codable {
  var page: Int
  var totalResults: Int
  var totalPages: Int
  var results: [Movie]
  
  private enum CodingKeys: String, CodingKey {
    case page
    case totalResults = "total_results"
    case totalPages = "total_pages"
    case results
  }
}

struct Movie: Codable {
  var popularity: Double
  var id: Int
  var video: Bool
  var voteCount: Double
  var voteAverage: Double
  var title: String
  var releaseDate: String
  var originalLanguage: String
  var originalTitle: String
  var genreIds: [Int]?
  var backdropPath: String?
  var adult: Bool
  var overview: String
  var posterPath: String?
  
  private enum CodingKeys: String, CodingKey {
    case popularity
    case id
    case video
    case voteCount = "vote_count"
    case voteAverage = "vote_average"
    case title
    case releaseDate = "release_date"
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case genreIds = "genre_ids"
    case backdropPath = "backdrop_path"
    case adult
    case overview
    case posterPath = "poster_path"
  }
}

struct MovieDescription: Codable {
  var adult: Bool
  var backdropPath: String?
  var belongsToCollection: String?
  var budget: Int
  var genres: [genres]
  var homepage: String?
  var id: Int
  var imdbId: String?
  var originalLanguage: String?
  var originalTitle: String
  var overview: String
  var popularity: Double
  var posterPath: String?
  var releaseDate: String
  var revenue: Int
  var status: String
  var title: String
  var voteCount: Double
  var voteAverage: Double

  private enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case belongsToCollection = "belongs_to_collection"
    case budget
    case genres
    case homepage
    case id
    case imdbId = "imdb_id"
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case overview
    case popularity
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case revenue = "revenue"
    case status
    case title
    case voteCount = "vote_count"
    case voteAverage = "vote_average"

  }
}

struct genres: Codable {
  var id: Int
  var name: String
}
