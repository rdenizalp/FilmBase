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
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    
    private let repository: MovieRepository
    
    private var currentPage = 1
    private var canLoadMorePages = true
    
    init(repository: MovieRepository = MovieRepositoryImpl()) {
        self.repository = repository
    }
    
    func loadMovies() async {
        isLoading = true
        errorMessage = nil
        currentPage = 1
        canLoadMorePages = true
        
        do {
            movies = try await repository.fetchTrending(page: currentPage)
            currentPage += 1
        } catch {
            if let networkError = error as? NetworkError {
                errorMessage = networkError.localizedDescription
            } else {
                errorMessage = NetworkError.unknown.localizedDescription
            }
        }
        
        isLoading = false
    }
    
    func loadMoreMoviesIfNeeded(currentMovie movie: Movie) async {
        guard let lastMovie = movies.last else { return }
        
        guard movie.id == lastMovie.id else { return }
        guard !isLoadingMore else { return }
        guard canLoadMorePages else { return }
        
        isLoadingMore = true
        
        do {
            let newMovies = try await repository.fetchTrending(page: currentPage)
            
            if newMovies.isEmpty {
                canLoadMorePages = false
            } else {
                movies.append(contentsOf: newMovies)
                currentPage += 1
            }
        } catch {
            canLoadMorePages = false
        }
        
        isLoadingMore = false
    }
}
