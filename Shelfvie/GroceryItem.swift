//
//  GroceryItem.swift
//  Shelfvie
//
//  Created by Saanvi Kakde on 12/17/25.
//

import Foundation

enum StorageLocation: String, CaseIterable, Identifiable, Codable {
    case fridge = "Fridge"
    case freezer = "Freezer"
    case pantry = "Pantry"

    var id: String { self.rawValue }
}

struct GroceryItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var expirationDate: Date
    var location: StorageLocation

    init(
        id: UUID = UUID(),
        name: String,
        expirationDate: Date,
        location: StorageLocation
    ) {
        self.id = id
        self.name = name
        self.expirationDate = expirationDate
        self.location = location
    }
}
