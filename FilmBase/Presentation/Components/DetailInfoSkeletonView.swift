//
//  DetailInfoSkeletonView.swift
//  FilmBase
//
//  Created by Deniz Alp on 10.05.2026.
//

import SwiftUI

struct DetailInfoSkeletonView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            skeletonBlock(width: 140, height: 18)
            
            HStack(spacing: 10) {
                skeletonBlock(width: 80, height: 28)
                skeletonBlock(width: 90, height: 28)
                skeletonBlock(width: 70, height: 28)
            }
            
            skeletonBlock(height: 48)
            
            skeletonBlock(width: 120, height: 22)
            
            HStack(spacing: 16) {
                ForEach(0..<4, id: \.self) { _ in
                    VStack(spacing: 8) {
                        skeletonCircle()
                        skeletonBlock(width: 70, height: 12)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func skeletonBlock(
        width: CGFloat? = nil,
        height: CGFloat
    ) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.25))
            
            ShimmerView()
                .mask(Rectangle())
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .clipped()
    }
    
    private func skeletonCircle() -> some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.25))
            
            ShimmerView()
                .mask(Circle())
        }
        .frame(width: 72, height: 72)
        .clipped()
    }
}

#Preview {
    DetailInfoSkeletonView()
        .background(Color("AppBackground"))
}
