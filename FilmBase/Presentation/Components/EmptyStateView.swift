//
//  EmptyStateView.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import SwiftUI

struct EmptyStateView: View {
    let iconName: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundStyle(Color("SecondaryText"))
            
            Text(title)
                .font(.headline)
                .foregroundStyle(Color("PrimaryText"))
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Color("SecondaryText"))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(
        iconName: "film",
        title: "No movies found",
        message: "Try searching with another title."
    )
    .background(Color("AppBackground"))
}
