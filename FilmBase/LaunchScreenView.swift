//
//  LaunchScreenView.swift
//  FilmBase
//
//  Created by Deniz Alp on 14.05.2026.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color("AppBackground")
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image("LaunchLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)

                Text("FilmBase")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("PrimaryText"))
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
