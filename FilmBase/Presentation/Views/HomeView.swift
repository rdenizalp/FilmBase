//
//  HomeView.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteMovies: [MovieEntity]
    
    private let repository: MovieRepository = MovieRepositoryImpl()
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("AppBackground")
                    .ignoresSafeArea()
                
                RadialGradient(
                    colors: [
                        Color("AccentColor").opacity(0.06),
                        .clear
                    ],
                    center: .topTrailing,
                    startRadius: 20,
                    endRadius: 420
                )
                .ignoresSafeArea()
                
                Group {
                    if viewModel.isLoading {
                        List {
                            ForEach(0..<6, id: \.self) { _ in
                                SkeletonMovieCardView()
                                    .listRowBackground(Color("AppBackground"))
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(
                                        EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                                    )
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color("AppBackground"))
                        
                    } else if let errorMessage = viewModel.errorMessage {
                        ErrorView(
                            title: "Something went wrong",
                            message: errorMessage,
                            retryTitle: "Try Again"
                        ) {
                            Task {
                                await viewModel.loadMovies()
                            }
                        }
                        
                    } else if viewModel.movies.isEmpty {
                        EmptyStateView(
                            iconName: "film",
                            title: "No movies found",
                            message: "Pull down to refresh or try again later."
                        )
                        
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("FilmBase")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color("PrimaryText"))
                                
                                Text("Trending Movies")
                                    .font(.subheadline)
                                    .foregroundStyle(Color("SecondaryText"))
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 10)
                            
                            List {
                                ForEach(viewModel.movies) { movie in
                                    ZStack {
                                        
                                        MovieCardView(
                                            movie: movie,
                                            isFavorite: isFavorite(movie),
                                            onFavoriteTap: {
                                                toggleFavorite(movie)
                                            }
                                        )
                                      
                                        NavigationLink(destination: DetailView(movie: movie)) {
                                            EmptyView()
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .contentShape(Rectangle())
                                        .opacity(0)
                                    }
                                    .transition(
                                        .opacity.combined(with: .move(edge: .bottom))
                                    )
                                    .swipeActions(edge: .trailing) {
                                        Button {
                                            toggleFavorite(movie)
                                        } label: {
                                            Label(
                                                isFavorite(movie) ? "Remove" : "Favorite",
                                                systemImage: isFavorite(movie) ? "star.slash" : "star.fill"
                                            )
                                        }
                                        .tint(isFavorite(movie) ? .red : Color("AccentGold"))
                                    }
                                    .onAppear {
                                        Task {
                                            await viewModel.loadMoreMoviesIfNeeded(currentMovie: movie)
                                        }
                                    }
                                    .listRowBackground(Color("AppBackground"))
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(
                                        EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                                    )
                                }
                                if viewModel.isLoadingMore {
                                    ProgressView()
                                        .tint(Color("AccentColor"))
                                        .frame(maxWidth: .infinity)
                                        .listRowBackground(Color("AppBackground"))
                                        .listRowSeparator(.hidden)
                                }
                            }
                            .listStyle(.plain)
                            .scrollContentBackground(.hidden)
                            .background(Color("AppBackground"))
                            .animation(
                                .easeInOut(duration: 0.25),
                                value: viewModel.movies
                            )
                            .refreshable {
                                await viewModel.loadMovies()
                            }
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.loadMovies()
        }
    }
    
    private func toggleFavorite(_ movie: Movie) {
        do {
            let favorite = isFavorite(movie)
            
            if favorite {
                try repository.removeFavorite(movie, context: modelContext)
                HapticManager.lightImpact()
            } else {
                try repository.addFavorite(movie, context: modelContext)
                HapticManager.success()
            }
        } catch {
            HapticManager.error()
            print("Favorite error: \(error)")
        }
    }
    
    private func isFavorite(_ movie: Movie) -> Bool {
        favoriteMovies.contains { entity in
            entity.id == movie.id
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: MovieEntity.self, inMemory: true)
}
