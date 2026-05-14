//
//  DetailView.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    let movie: Movie
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorite = false
    @StateObject private var viewModel = DetailViewModel()
    @State private var isPressingTrailer = false
    
    private let repository: MovieRepository = MovieRepositoryImpl()
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    headerImage(width: proxy.size.width)
                    movieInfo
                }
                .padding(.bottom, 120)
            }
            .ignoresSafeArea(edges: .top)
            .background(
                Color("AppBackground")
                    .ignoresSafeArea()
            )
            .overlay(alignment: .topLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("PrimaryText"))
                        .frame(width: 48, height: 48)
                        .background(Color("CardBackground").opacity(0.75))
                        .clipShape(Circle())
                }
                .padding(.leading, 20)
                .padding(.top, 54)
            }
            .onAppear {
                checkFavoriteStatus()
            }
            .task {
                await viewModel.loadMovieDetail(id: movie.id)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
    
    private func headerImage(width: CGFloat) -> some View {
        ZStack(alignment: .bottomLeading) {
            
            CachedAsyncImage(url: movie.backdropURL ?? movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ZStack {
                    Color("CardBackground")
                    
                    Image(systemName: "film")
                        .font(.largeTitle)
                        .foregroundStyle(Color("SecondaryText"))
                }
            }
            .frame(width: width, height: 340)
            .clipped()
            
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.25),
                    .init(color: Color("AppBackground").opacity(0.75), location: 0.62),
                    .init(color: Color("AppBackground"), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: width, height: 340)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("PrimaryText"))
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Button {
                        toggleFavorite()
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .font(.title2)
                            .foregroundStyle(Color("AccentGold"))
                            .scaleEffect(isFavorite ? 1.12 : 1)
                            .animation(
                                .easeInOut(duration: 0.18),
                                value: isFavorite
                            )
                    }
                    .buttonStyle(.plain)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color("AccentGold"))
                    
                    Text(String(format: "%.1f", movie.voteAverage))
                        .foregroundStyle(Color("PrimaryText"))
                    
                    if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
                        Text("• \(releaseDate)")
                            .foregroundStyle(Color("SecondaryText"))
                    }
                }
                .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 14)
        }
        .frame(width: width, height: 340)
    }
    
    private var movieInfo: some View {
        VStack(alignment: .leading, spacing: 14) {
            detailStateContent
            overviewSection
        }
        .padding(.horizontal, 20)
    }
    @ViewBuilder
    private var detailStateContent: some View {
        if viewModel.isLoading {
            DetailInfoSkeletonView()
                .padding(.horizontal, -20)
            
        } else if let errorMessage = viewModel.errorMessage {
            ErrorView(
                title: "Couldn’t load details",
                message: errorMessage,
                retryTitle: "Try Again"
            ) {
                Task {
                    await viewModel.loadMovieDetail(id: movie.id)
                }
            }
            .padding(.horizontal, -20)
            
        } else {
            detailMetadataSection
            trailerButton
            castSection
        }
    }
    @ViewBuilder
    private var detailMetadataSection: some View {
        if let detail = viewModel.movieDetail {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Text(detail.formattedRuntime)
                    Text("•")
                    Text(detail.formattedVoteCount)
                }
                .font(.subheadline)
                .foregroundStyle(Color("SecondaryText"))
                
                if !detail.genres.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(detail.genres) { genre in
                                GenreChipView(title: genre.name)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var trailerButton: some View {
        if let trailerURL = viewModel.trailerURL {
            Button {
                HapticManager.mediumImpact()
                openURL(trailerURL)
            } label: {
                HStack {
                    Image(systemName: "play.fill")
                    
                    Text("Watch Trailer")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color("AccentGold"))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .scaleEffect(isPressingTrailer ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.12), value: isPressingTrailer)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        isPressingTrailer = true
                    }
                    .onEnded { _ in
                        isPressingTrailer = false
                    }
            )
        }
    }
    
    @ViewBuilder
    private var castSection: some View {
        if !viewModel.cast.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Cast")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("PrimaryText"))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.cast.prefix(10)) { member in
                            VStack(spacing: 8) {
                                CachedAsyncImage(url: member.profileURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ZStack {
                                        Circle()
                                            .fill(Color("CardBackground"))
                                        
                                        Image(systemName: "person.fill")
                                            .font(.title3)
                                            .foregroundStyle(Color("SecondaryText"))
                                    }
                                }
                                .frame(width: 72, height: 72)
                                .clipShape(Circle())
                                
                                VStack(spacing: 2) {
                                    Text(member.name)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color("PrimaryText"))
                                        .lineLimit(1)
                                    
                                    Text(member.character)
                                        .font(.caption2)
                                        .foregroundStyle(Color("SecondaryText"))
                                        .lineLimit(1)
                                }
                                .frame(width: 80)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Overview")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color("PrimaryText"))
            
            Text(movie.overview.isEmpty ? "No overview available." : movie.overview)
                .font(.body)
                .foregroundStyle(Color("SecondaryText"))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func checkFavoriteStatus() {
        do {
            isFavorite = try repository.isFavorite(movie, context: modelContext)
        } catch {
            isFavorite = false
        }
    }
    
    private func toggleFavorite() {
        do {
            if isFavorite {
                try repository.removeFavorite(movie, context: modelContext)
                isFavorite = false
                HapticManager.lightImpact()
            } else {
                try repository.addFavorite(movie, context: modelContext)
                isFavorite = true
                HapticManager.success()
            }
        } catch {
            HapticManager.error()
            print("Favorite error: \(error)")
        }
    }
}

#Preview {
    DetailView(
        movie: Movie(
            id: 1,
            title: "The Dark Knight",
            overview: "Batman faces the Joker in Gotham City.",
            posterPath: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
            backdropPath: nil,
            voteAverage: 8.5,
            releaseDate: "2008-07-18"
        )
    )
    .modelContainer(for: MovieEntity.self, inMemory: true)
}
