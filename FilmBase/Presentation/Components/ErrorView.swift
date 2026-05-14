//
//  ErrorView.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import SwiftUI

struct ErrorView: View {
    let title: String
    let message: String
    let retryTitle: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(Color("AccentGold"))
            
            Text(title)
                .font(.headline)
                .foregroundStyle(Color("PrimaryText"))
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Color("SecondaryText"))
                .multilineTextAlignment(.center)
            
            Button {
                HapticManager.lightImpact()
                onRetry()
            } label: {
                Text(retryTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color("AccentGold"))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorView(
        title: "Something went wrong",
        message: "Failed to load movies.",
        retryTitle: "Try Again",
        onRetry: {}
    )
    .background(Color("AppBackground"))
}
