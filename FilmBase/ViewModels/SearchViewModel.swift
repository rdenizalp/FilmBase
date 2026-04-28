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
            errorMessage = "Failed to search movies."
        }
        
        isLoading = false
    }
}
