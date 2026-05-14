//
//  FilmBaseApp.swift
//  FilmBase
//
//  Created by Deniz Alp on 11.04.2026.
//

import SwiftUI
import SwiftData

@main
struct FilmBaseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: MovieEntity.self)
    }
}
