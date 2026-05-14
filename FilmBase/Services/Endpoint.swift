//
//  Endpoint.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation

enum Endpoint {
    case trending(page: Int)
    case search(query: String)
    case detail(id: Int)
    case videos(id: Int)
    case credits(id: Int)

    var url: URL? {
        switch self {
        case .trending(let page):
            return URL(string: "\(Config.baseURL)/trending/movie/week?api_key=\(Config.apiKey)&page=\(page)")
        case .search(let query):
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return URL(string: "\(Config.baseURL)/search/movie?api_key=\(Config.apiKey)&query=\(encoded)")
        case .detail(let id):
            return URL(string: "\(Config.baseURL)/movie/\(id)?api_key=\(Config.apiKey)")
        case .videos(let id):
            return URL(string: "\(Config.baseURL)/movie/\(id)/videos?api_key=\(Config.apiKey)")
        case .credits(let id):
            return URL(string: "\(Config.baseURL)/movie/\(id)/credits?api_key=\(Config.apiKey)")
        }
    }
}
