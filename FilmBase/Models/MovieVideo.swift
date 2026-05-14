//
//  MovieVideo.swift
//  FilmBase
//
//  Created by Deniz Alp on 8.05.2026.
//

import Foundation

struct MovieVideoResponse: Decodable {
    let results: [MovieVideo]
}

struct MovieVideo: Decodable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
}
