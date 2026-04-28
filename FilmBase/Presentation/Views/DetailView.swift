//
//  DetailView.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import SwiftUI

struct DetailView: View {
    let movie: Movie
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerImage(width: proxy.size.width)
                    movieInfo
                }
            }
            .background(Color("AppBackground").ignoresSafeArea())
        }
    }
    
    private func headerImage(width: CGFloat) -> some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: movie.backdropURL ?? movie.posterURL) { phase in
                switch phase {
                case .empty:
                    Color("CardBackground")
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                    
                case .failure:
                    Color("CardBackground")
                    
                @unknown default:
                    Color("CardBackground")
                }
            }
            .frame(width: width, height: 360)
            .clipped()
            
            LinearGradient(
                colors: [
                    .clear,
                    Color("AppBackground").opacity(0.85),
                    Color("AppBackground")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: width, height: 360)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PrimaryText"))
                    .lineLimit(2)
                
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
            .frame(width: width - 40, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
        }
        .frame(width: width, height: 360)
    }
    
    private var movieInfo: some View {
        VStack(alignment: .leading, spacing: 14) {
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
        .padding(.horizontal, 20)
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
}
