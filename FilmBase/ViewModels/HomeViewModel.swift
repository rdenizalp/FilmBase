//
//  HomeViewModel.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: MovieRepository

    init(repository: MovieRepository = MovieRepositoryImpl()) {
        self.repository = repository
    }

    func loadMovies() async {
        isLoading = true
        errorMessage = nil

        do {
            movies = try await repository.fetchTrending()
        } catch {
            errorMessage = "Failed to load movies"
        }

        isLoading = false
    }
}
