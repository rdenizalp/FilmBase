//
//  SkeletonMovieCardView.swift
//  FilmBase
//
//  Created by Deniz Alp on 28.04.2026.
//

import SwiftUI

struct SkeletonMovieCardView: View {
    
    var body: some View {
        HStack(spacing: 16) {
            skeletonBlock(width: 100, height: 150, cornerRadius: 12)
            
            VStack(alignment: .leading, spacing: 10) {
                skeletonBlock(height: 20, cornerRadius: 6)
                skeletonBlock(height: 16, cornerRadius: 6)
                skeletonBlock(width: 80, height: 16, cornerRadius: 6)
            }
        }
        .padding()
        .background(Color("CardBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private func skeletonBlock(
        width: CGFloat? = nil,
        height: CGFloat,
        cornerRadius: CGFloat
    ) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.25))
            
            ShimmerView()
                .mask(
                    Rectangle()
                        .fill(Color.white)
                )
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .clipped()
    }
}

#Preview {
    SkeletonMovieCardView()
        .padding()
        .background(Color("AppBackground"))
}
