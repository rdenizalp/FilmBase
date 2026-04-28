//
//  MovieAPIService.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation

final class MovieAPIService {

    func fetchTrending() async throws -> [Movie] {
        guard let url = Endpoint.trending.url else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decoded.results
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
}
