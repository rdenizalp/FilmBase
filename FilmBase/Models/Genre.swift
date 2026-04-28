//
//  Genre.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import Foundation

struct Genre: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
}
