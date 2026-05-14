//
//  ImageCache.swift
//  FilmBase
//
//  Created by Deniz Alp on 8.05.2026.
//

import SwiftUI

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func insert(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
