//
//  MovieRepositoryImpl.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation

final class MovieRepositoryImpl: MovieRepository {

    private let apiService: MovieAPIService

    init(apiService: MovieAPIService = MovieAPIService()) {
        self.apiService = apiService
    }

    func fetchTrending() async throws -> [Movie] {
        try await apiService.fetchTrending()
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        try await apiService.searchMovies(query: query)
    }
}
