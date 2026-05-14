//
//  MovieCardView.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//
import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let isFavorite: Bool
    let onFavoriteTap: (() -> Void)?

    var body: some View {
        HStack(spacing: 14) {
            
            CachedAsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ZStack {
                    Color("CardBackground")
                    
                    Image(systemName: "film")
                        .font(.title2)
                        .foregroundStyle(Color("SecondaryText"))
                }
            }
            .frame(width: 85, height: 125)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(movie.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("PrimaryText"))
                    .lineLimit(2)
                
                if let releaseDate = movie.releaseDate {
                    Text(releaseDate)
                        .font(.caption)
                        .foregroundStyle(Color("SecondaryText"))
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(Color("AccentGold"))
                    
                    Text(String(format: "%.1f", movie.voteAverage))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color("PrimaryText"))
                }
            }
            
            Spacer()

            if let onFavoriteTap {
                Button {
                    onFavoriteTap()
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .font(.title3)
                        .foregroundStyle(Color("AccentGold"))
                        .scaleEffect(isFavorite ? 1.12 : 1)
                        .animation(
                            .easeInOut(duration: 0.18),
                            value: isFavorite
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color("CardBackground"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.04))
        )
        .shadow(
            color: Color("AccentColor").opacity(0.12),
            radius: 16,
            x: 0,
            y: 8
        )
        .shadow(
            color: .black.opacity(0.35),
            radius: 10,
            x: 0,
            y: 4
        )
    }

    private var placeholder: some View {
        ZStack {
            Color("CardBackground")
            
            Image(systemName: "film")
                .font(.title2)
                .foregroundStyle(Color("SecondaryText"))
        }
    }
}

#Preview {
    MovieCardView(
        movie: Movie(
            id: 1,
            title: "The Dark Knight",
            overview: "Batman faces the Joker in Gotham City.",
            posterPath: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
            backdropPath: nil,
            voteAverage: 8.5,
            releaseDate: "2008-07-18"
        ),
        isFavorite: true,
        onFavoriteTap: nil
    )
    .padding()
    .background(Color("AppBackground"))
}
