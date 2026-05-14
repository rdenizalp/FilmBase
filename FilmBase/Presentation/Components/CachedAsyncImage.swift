//
//  CachedAsyncImage.swift
//  FilmBase
//
//  Created by Deniz Alp on 8.05.2026.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image {
                content(Image(uiImage: image))
            } else {
                placeholder()
                    .task {
                        await loadImage()
                    }
            }
        }
    }
    
    private func loadImage() async {
        guard let url else { return }
        
        if let cachedImage = ImageCache.shared.image(for: url) {
            image = cachedImage
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let downloadedImage = UIImage(data: data) else { return }
            
            ImageCache.shared.insert(downloadedImage, for: url)
            image = downloadedImage
        } catch {
            print("Image loading error: \(error)")
        }
    }
}
