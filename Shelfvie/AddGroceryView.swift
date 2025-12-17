//
//  AddGroceryView.swift
//  Shelfvie
//
//  Created by Saanvi Kakde on 12/17/25.
//

import SwiftUI

struct AddGroceryView: View {

    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var expirationDate: Date = Date()
    @State private var location: StorageLocation = .fridge

    var onSave: (GroceryItem) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item name", text: $name)

                    Picker("Storage Location", selection: $location) {
                        ForEach(StorageLocation.allCases) { location in
                            Text(location.rawValue).tag(location)
                        }
                    }

                    DatePicker(
                        "Expiration Date",
                        selection: $expirationDate,
                        displayedComponents: .date
                    )
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newItem = GroceryItem(
                            name: name,
                            expirationDate: expirationDate,
                            location: location
                        )
                        onSave(newItem)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

