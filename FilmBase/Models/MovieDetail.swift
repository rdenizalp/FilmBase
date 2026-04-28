//
//  MovieDetail.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation

struct MovieDetail: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: String?
    let runtime: Int?
    let genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case runtime
        case genres
    }
}
