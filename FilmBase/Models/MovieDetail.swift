//
//  MovieDetail.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation

struct MovieDetail: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let voteCount: Int?
    let releaseDate: String?
    let runtime: Int?
    let genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case runtime
        case genres
    }
    
    var formattedRuntime: String {
        guard let runtime else { return "N/A" }
        
        let hours = runtime / 60
        let minutes = runtime % 60
        
        return "\(hours)h \(minutes)m"
    }
    
    var formattedVoteCount: String {
        guard let voteCount else { return "N/A" }
        
        if voteCount >= 1_000_000 {
            let value = Double(voteCount) / 1_000_000
            return String(format: "%.1fM votes", value)
        } else if voteCount >= 1_000 {
            let value = Double(voteCount) / 1_000
            return String(format: "%.1fK votes", value)
        } else {
            return "\(voteCount) votes"
        }
    }
    
    var genreText: String {
        genres.map { $0.name }.joined(separator: ", ")
    }
}
