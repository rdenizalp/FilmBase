//
//  NetworkError.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//
import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case noInternet
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Something went wrong with the request."
        case .invalidResponse:
            return "The server didn’t respond correctly. Please try again."
        case .decodingError:
            return "We couldn’t read the movie data. Please try again later."
        case .noInternet:
            return "No internet connection. Please check your connection and try again."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
