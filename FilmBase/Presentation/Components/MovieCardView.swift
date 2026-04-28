//
//  MovieCardView.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//
import SwiftUI

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 14) {
            
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .empty:
                    placeholder
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    placeholder
                @unknown default:
                    placeholder
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
        .shadow(color: .black.opacity(0.6), radius: 8, x: 0, y: 4)
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
        )
    )
    .padding()
    .background(Color("AppBackground"))
}
