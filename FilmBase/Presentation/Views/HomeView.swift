//
//  HomeView.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("AppBackground")
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
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundStyle(Color("AccentGold"))
                            
                            Text(errorMessage)
                                .foregroundStyle(Color("PrimaryText"))
                            
                            Button("Try Again") {
                                Task {
                                    await viewModel.loadMovies()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        
                    } else if viewModel.movies.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "film")
                                .font(.largeTitle)
                                .foregroundStyle(Color("SecondaryText"))
                            
                            Text("No movies found")
                                .foregroundStyle(Color("PrimaryText"))
                        }
                        
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
}

#Preview {
    HomeView()
}
