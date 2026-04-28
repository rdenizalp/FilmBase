//
//  ShimmerView.swift
//  FilmBase
//
//  Created by Deniz Alp on 28.04.2026.
//

import SwiftUI

struct ShimmerView: View {
    
    @State private var moveGradient = false
    
    var body: some View {
        LinearGradient(
            colors: [
                Color.white.opacity(0.05),
                Color.white.opacity(0.25),
                Color.white.opacity(0.05)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .rotationEffect(.degrees(20))
        .offset(x: moveGradient ? 250 : -250)
        .onAppear {
            withAnimation(
                .linear(duration: 1.2)
                .repeatForever(autoreverses: false)
            ) {
                moveGradient = true
            }
        }
    }
}
