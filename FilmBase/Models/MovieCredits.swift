//
//  MovieCredits.swift
//  FilmBase
//
//  Created by Deniz Alp on 8.05.2026.
//

import Foundation

struct MovieCreditsResponse: Decodable {
    let cast: [CastMember]
}

struct CastMember: Decodable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
    
    var profileURL: URL? {
        guard let profilePath else { return nil }
        return URL(string: "\(Config.imageBaseURL)\(profilePath)")
    }
}
