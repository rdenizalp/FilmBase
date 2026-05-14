//
//  SearchView.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteMovies: [MovieEntity]
    @FocusState private var isSearchFocused: Bool
    
    private let repository: MovieRepository = MovieRepositoryImpl()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("AppBackground")
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 18) {
                    searchHeader
                    
                    Group {
                        if viewModel.searchText.isEmpty {
                            emptySearchView
                        }  else if viewModel.isLoading {
                            List {
                                ForEach(0..<4, id: \.self) { _ in
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
                                    await viewModel.searchMovies()
                                }
                            }
                        } else if viewModel.movies.isEmpty {
                            noResultsView
                        } else {
                            searchResultsList
                        }
                    }
                }
            }
            .onChange(of: viewModel.searchText) {
                viewModel.searchWithDebounce()
            }
            .onSubmit(of: .search) {
                Task {
                    await viewModel.searchMovies()
                }
            }
        }
        .task {
            await viewModel.loadSuggestions()
        }
    }
    
    private var searchHeader: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Discover")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PrimaryText"))
                
                Text("Search your favorite movies")
                    .font(.subheadline)
                    .foregroundStyle(Color("SecondaryText"))
            }
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color("SecondaryText"))
                
                TextField("Search movies...", text: $viewModel.searchText)
                    .foregroundStyle(Color("PrimaryText"))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .focused($isSearchFocused)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color("CardBackground"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isSearchFocused
                        ? Color("AccentColor").opacity(0.38)
                        : Color.white.opacity(0.05),
                        lineWidth: isSearchFocused ? 1.2 : 1
                    )
            )
            .shadow(
                color: isSearchFocused
                ? Color("AccentColor").opacity(0.10)
                : .clear,
                radius: 12,
                x: 0,
                y: 4
            )
            .animation(.easeInOut(duration: 0.18), value: isSearchFocused)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchResultsList: some View {
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
    }
    
    private var emptySearchView: some View {
        VStack(spacing: 18) {
            EmptyStateView(
                iconName: "magnifyingglass",
                title: "Search for a movie",
                message: "Find movies by title or try a popular search."
            )
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Popular Searches")
                    .font(.headline)
                    .foregroundStyle(Color("PrimaryText"))
                
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 130), spacing: 10)
                    ],
                    spacing: 10
                ) {
                    ForEach(viewModel.suggestions, id: \.self) { suggestion in
                        Button {
                            HapticManager.lightImpact()
                            viewModel.searchText = suggestion
                            viewModel.searchWithDebounce()
                        } label: {
                            Text(suggestion)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color("PrimaryText"))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 9)
                                .frame(maxWidth: .infinity)
                                .background(Color("CardBackground"))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    private var noResultsView: some View {
        EmptyStateView(
            iconName: "film",
            title: "No results found",
            message: "Try searching with another title."
        )
    }
    
    
    private func isFavorite(_ movie: Movie) -> Bool {
        favoriteMovies.contains { entity in
            entity.id == movie.id
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
}

#Preview {
    SearchView()
        .modelContainer(for: MovieEntity.self, inMemory: true)
}
