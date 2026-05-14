//
//  SearchViewModel.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var suggestions: [String] = []
    
    private let repository: MovieRepository
    private var searchTask: Task<Void, Never>?
    
    init(repository: MovieRepository = MovieRepositoryImpl()) {
        self.repository = repository
    }
    
    func searchWithDebounce() {
        searchTask?.cancel()
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            if Task.isCancelled { return }
            
            await searchMovies()
        }
    }
    
    func searchMovies() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            movies = []
            errorMessage = nil
            isLoading = false
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            movies = try await repository.searchMovies(query: query)
        } catch {
            if let networkError = error as? NetworkError {
                errorMessage = networkError.localizedDescription
            } else {
                errorMessage = NetworkError.unknown.localizedDescription
            }
        }
        isLoading = false
    }
    
    func loadSuggestions() async {
        do {
            let movies = try await repository.fetchTrending(page: 1)
            suggestions = movies
                .map { $0.title }
                .prefix(8)
                .map { String($0) }
        } catch {
            suggestions = [
                "Batman",
                "Spider-Man",
                "Dune",
                "Avengers",
                "Horror",
                "Comedy"
            ]
        }
    }
}
