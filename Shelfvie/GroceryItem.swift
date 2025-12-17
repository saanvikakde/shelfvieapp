//
//  GroceryItem.swift
//  Shelfvie
//
//  Created by Saanvi Kakde on 12/17/25.
//

import Foundation

enum StorageLocation: String, CaseIterable, Identifiable {
    case fridge = "Fridge"
    case freezer = "Freezer"
    case pantry = "Pantry"

    var id: String { self.rawValue }
}

struct GroceryItem: Identifiable {
    let id = UUID()
    var name: String
    var expirationDate: Date
    var location: StorageLocation
}
