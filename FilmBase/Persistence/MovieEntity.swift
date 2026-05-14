//
//  MovieEntity.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation
import SwiftData

@Model
final class MovieEntity {
    @Attribute(.unique) var id: Int
    var title: String
    var overview: String
    var posterPath: String?
    var backdropPath: String?
    var voteAverage: Double
    var releaseDate: String?
    var isFavorite: Bool
    var createdAt: Date
    
    init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String?,
        backdropPath: String?,
        voteAverage: Double,
        releaseDate: String?,
        isFavorite: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }
    
    convenience init(movie: Movie) {
        self.init(
            id: movie.id,
            title: movie.title,
            overview: movie.overview,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            voteAverage: movie.voteAverage,
            releaseDate: movie.releaseDate
        )
    }
}
