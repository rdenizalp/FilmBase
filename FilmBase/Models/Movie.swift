//
//  Movie.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation

struct Movie: Decodable, Identifiable, Equatable {
    
    // MARK: - Properties
    
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: String?
    
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
    
    
    // MARK: - Computed Properties
    
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "\(Config.imageBaseURL)\(posterPath)")
    }
    
    var backdropURL: URL? {
        guard let backdropPath else { return nil }
        return URL(string: "\(Config.imageBaseURL)\(backdropPath)")
    }
    
    
    // MARK: - Initializers
    
    init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String?,
        backdropPath: String?,
        voteAverage: Double,
        releaseDate: String?
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
    }
    
    init(entity: MovieEntity) {
        self.id = entity.id
        self.title = entity.title
        self.overview = entity.overview
        self.posterPath = entity.posterPath
        self.backdropPath = entity.backdropPath
        self.voteAverage = entity.voteAverage
        self.releaseDate = entity.releaseDate
    }
}
