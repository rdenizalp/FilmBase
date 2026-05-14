//
//  MovieRepository.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation
import SwiftData

protocol MovieRepository {
    func fetchTrending(page: Int) async throws -> [Movie]
    func searchMovies(query: String) async throws -> [Movie]
    func fetchMovieDetail(id: Int) async throws -> MovieDetail
    func fetchMovieVideos(id: Int) async throws -> [MovieVideo]
    func fetchMovieCredits(id: Int) async throws -> [CastMember]
    
    func addFavorite(_ movie: Movie, context: ModelContext) throws
    func removeFavorite(_ movie: Movie, context: ModelContext) throws
    func isFavorite(_ movie: Movie, context: ModelContext) throws -> Bool
}
