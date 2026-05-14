//
//  FavoritesViewModel.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(
        filter: #Predicate<MovieEntity> { movie in
            movie.isFavorite == true
        },
        sort: \MovieEntity.createdAt,
        order: .reverse
    )
    private var favoriteMovies: [MovieEntity]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("AppBackground")
                    .ignoresSafeArea()
                .ignoresSafeArea()
                
                
                if favoriteMovies.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(favoriteMovies) { entity in
                            
                            let movie = Movie(entity: entity)
                            
                            ZStack {
                                MovieCardView(
                                    movie: movie,
                                    isFavorite: true,
                                    onFavoriteTap: {
                                        deleteFavorite(entity)
                                    }
                                )
                                
                                NavigationLink(destination: DetailView(movie: movie)) {
                                    EmptyView()
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .opacity(0)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteFavorite(entity)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .listRowBackground(Color("AppBackground"))
                            .listRowSeparator(.hidden)
                            .listRowInsets(
                                EdgeInsets(
                                    top: 8,
                                    leading: 16,
                                    bottom: 8,
                                    trailing: 16
                                )
                            )
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color("AppBackground"))
                }
            }
            .navigationTitle("Favorites")
        }
    }
    
    private var emptyState: some View {
        EmptyStateView(
            iconName: "star",
            title: "No favorite movies yet",
            message: "Movies you favorite will appear here."
        )
    }
    
    private func deleteFavorite(_ entity: MovieEntity) {
        modelContext.delete(entity)
        
        do {
            try modelContext.save()
        } catch {
            print("Delete favorite error: \(error)")
        }
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: MovieEntity.self, inMemory: true)
}
