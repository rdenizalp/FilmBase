//
//  MovieAPIService.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation

final class MovieAPIService {

    func fetchTrending(page: Int) async throws -> [Movie] {
        guard let url = Endpoint.trending(page: page).url else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decodedResponse.results
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        guard let url = Endpoint.search(query: query).url else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decodedResponse.results
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        guard let url = Endpoint.detail(id: id).url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(MovieDetail.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func fetchMovieVideos(id: Int) async throws -> [MovieVideo] {
        guard let url = Endpoint.videos(id: id).url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(MovieVideoResponse.self, from: data)
            return decodedResponse.results
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func fetchMovieCredits(id: Int) async throws -> [CastMember] {
        guard let url = Endpoint.credits(id: id).url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(MovieCreditsResponse.self, from: data)
            return decodedResponse.cast
        } catch {
            throw NetworkError.decodingError
        }
    }
}
