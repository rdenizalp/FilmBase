//
//  Endpoint.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation

enum Endpoint {
    case trending
    case search(query: String)
    case detail(id: Int)

    var url: URL? {
        switch self {
        case .trending:
            return URL(string: "\(Config.baseURL)/trending/movie/week?api_key=\(Config.apiKey)")
        case .search(let query):
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return URL(string: "\(Config.baseURL)/search/movie?api_key=\(Config.apiKey)&query=\(encoded)")
        case .detail(let id):
            return URL(string: "\(Config.baseURL)/movie/\(id)?api_key=\(Config.apiKey)")
        }
    }
}
