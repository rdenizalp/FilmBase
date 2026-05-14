//
//  GenreChipView.swift
//  FilmBase
//
//  Created by Deniz Alp on 17.04.2026.
//

import SwiftUI

struct GenreChipView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(Color("PrimaryText"))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color("CardBackground"))
            .clipShape(Capsule())
    }
}

#Preview {
    GenreChipView(title: "Action")
        .background(Color("AppBackground"))
}
