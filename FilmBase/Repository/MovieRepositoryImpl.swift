//
//  MovieRepositoryImpl.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation
import SwiftData

final class MovieRepositoryImpl: MovieRepository {
    
    private let apiService: MovieAPIService
    
    init(apiService: MovieAPIService = MovieAPIService()) {
        self.apiService = apiService
    }
    
    func fetchTrending(page: Int) async throws -> [Movie] {
        try await apiService.fetchTrending(page: page)
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        try await apiService.searchMovies(query: query)
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        try await apiService.fetchMovieDetail(id: id)
    }
    
    func fetchMovieVideos(id: Int) async throws -> [MovieVideo] {
        try await apiService.fetchMovieVideos(id: id)
    }
    func fetchMovieCredits(id: Int) async throws -> [CastMember] {
        try await apiService.fetchMovieCredits(id: id)
    }
    func addFavorite(_ movie: Movie, context: ModelContext) throws {
        let movieID = movie.id
        
        let descriptor = FetchDescriptor<MovieEntity>(
            predicate: #Predicate { entity in
                entity.id == movieID
            }
        )
        
        let existing = try context.fetch(descriptor)
        
        if existing.isEmpty {
            let entity = MovieEntity(movie: movie)
            context.insert(entity)
        } else {
            existing.first?.isFavorite = true
        }
        
        try context.save()
    }
    
    func removeFavorite(_ movie: Movie, context: ModelContext) throws {
        let movieID = movie.id
        
        let descriptor = FetchDescriptor<MovieEntity>(
            predicate: #Predicate { entity in
                entity.id == movieID
            }
        )
        
        let results = try context.fetch(descriptor)
        
        for entity in results {
            context.delete(entity)
        }
        
        try context.save()
    }
    
    func isFavorite(_ movie: Movie, context: ModelContext) throws -> Bool {
        let movieID = movie.id
        
        let descriptor = FetchDescriptor<MovieEntity>(
            predicate: #Predicate { entity in
                entity.id == movieID
            }
        )
        
        let results = try context.fetch(descriptor)
        return !results.isEmpty
    }
}
