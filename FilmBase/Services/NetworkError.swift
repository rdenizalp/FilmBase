//
//  NetworkError.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
