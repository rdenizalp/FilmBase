//
//  Movie.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation

struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
    
  
    var posterURL: URL? {

            guard let posterPath else { return nil }
            return URL(string: "\(Config.imageBaseURL)\(posterPath)")

        }
    
    var backdropURL: URL? {
        guard let backdropPath else { return nil }
        return URL(string: "\(Config.imageBaseURL)\(backdropPath)")
    }
}
