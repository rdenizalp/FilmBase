//
//  Item.swift
//  FilmBase
//
//  Created by Deniz Alp on 11.04.2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
