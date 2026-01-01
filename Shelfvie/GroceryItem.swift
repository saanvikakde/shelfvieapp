//
//  GroceryItem.swift
//  Shelfvie
//
//  Created by Saanvi Kakde on 12/17/25.
//

import Foundation // library for data handling


// define StorageLocation

enum StorageLocation: String, CaseIterable, Identifiable, Codable {
    case fridge = "Fridge"
    case freezer = "Freezer"
    case pantry = "Pantry"
    
    var id: String {self.rawValue}
}
// GroceryItem constructor

struct GroceryItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var location: StorageLocation
    var expirationDate: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        expirationDate: Date,
        location: StorageLocation

        
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.expirationDate = expirationDate
    }
    
}
