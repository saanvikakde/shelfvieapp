//
//  AddGroceryView.swift
//  Shelfvie
//
//  Created by Saanvi Kakde on 12/17/25.
//

import SwiftUI

struct AddGroceryView: View {

    @Environment(\.dismiss) var dismiss

    @State private var name: String
    @State private var expirationDate: Date
    @State private var location: StorageLocation

    let editingItem: GroceryItem?
    var onSave: (GroceryItem) -> Void

    init(editingItem: GroceryItem? = nil, onSave: @escaping (GroceryItem) -> Void) {
        self.editingItem = editingItem
        self.onSave = onSave

        _name = State(initialValue: editingItem?.name ?? "")
        _expirationDate = State(initialValue: editingItem?.expirationDate ?? Date())
        _location = State(initialValue: editingItem?.location ?? .fridge)
    }

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
            .navigationTitle(editingItem == nil ? "Add Item" : "Edit Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = GroceryItem(
                            id: editingItem?.id ?? UUID(),
                            name: name,
                            expirationDate: expirationDate,
                            location: location
                        )
                        onSave(item)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
