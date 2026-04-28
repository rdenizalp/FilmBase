//
//  MovieRepository.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation

protocol MovieRepository {
    func fetchTrending() async throws -> [Movie]
    func searchMovies(query: String) async throws -> [Movie]
}
