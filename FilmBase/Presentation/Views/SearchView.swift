//
//  SearchView.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("AppBackground")
                    .ignoresSafeArea()
                
                Group {
                    if viewModel.searchText.isEmpty {
                        emptySearchView
                    } else if viewModel.isLoading {
                        ProgressView()
                            .tint(Color("AccentColor"))
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(Color("PrimaryText"))
                    } else if viewModel.movies.isEmpty {
                        Text("No results found")
                            .foregroundStyle(Color("SecondaryText"))
                    } else {
                        List {
                            ForEach(viewModel.movies) { movie in
                                ZStack {
                                    MovieCardView(movie: movie)
                                    
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
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchText, prompt: "Search movies")
            .onChange(of: viewModel.searchText) {
                viewModel.searchWithDebounce()
            }
            .onSubmit(of: .search) {
                Task {
                    await viewModel.searchMovies()
                }
            }
        }
    }
    
    private var emptySearchView: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundStyle(Color("SecondaryText"))
            
            Text("Search for a movie")
                .font(.headline)
                .foregroundStyle(Color("PrimaryText"))
            
            Text("Find movies by title.")
                .font(.subheadline)
                .foregroundStyle(Color("SecondaryText"))
        }
    }
}

#Preview {
    SearchView()
}
