//
//  DetailViewModel.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation
import Combine

@MainActor
final class DetailViewModel: ObservableObject {
    
    @Published var movieDetail: MovieDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var trailerURL: URL?
    @Published var cast: [CastMember] = []
    
    private let repository: MovieRepository
    
    init(repository: MovieRepository = MovieRepositoryImpl()) {
        self.repository = repository
    }
    
    func loadMovieDetail(id: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            movieDetail = try await repository.fetchMovieDetail(id: id)
            
            let videos = try await repository.fetchMovieVideos(id: id)
            
            if let trailer = videos.first(where: { $0.site == "YouTube" && $0.type == "Trailer" }) {
                trailerURL = URL(string: "https://www.youtube.com/watch?v=\(trailer.key)")
            }
            
            cast = try await repository.fetchMovieCredits(id: id)
            
        } catch {
            if let networkError = error as? NetworkError {
                errorMessage = networkError.localizedDescription
            } else {
                errorMessage = NetworkError.unknown.localizedDescription
            }
        }
        
        isLoading = false
    }
}
