//
//  GroceryListView.swift
//  Shelfvie
//
//  Created by Saanvi Kakde on 12/17/25.
//

import SwiftUI

struct GroceryListView: View {

    let title: String
    @Binding var groceries: [GroceryItem]
    let location: StorageLocation
    let onDelete: () -> Void
    let onEdit: (GroceryItem) -> Void

    var filteredGroceries: [GroceryItem] {
        groceries
            .filter { $0.location == location }
            .sorted { $0.expirationDate < $1.expirationDate }
    }

    var body: some View {
        List {
            ForEach(filteredGroceries) { item in
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)

                    Text("Expires \(item.expirationDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onEdit(item)
                }
            }
            .onDelete { indexSet in
                deleteItems(at: indexSet)
            }
        }
        .navigationTitle(title)
    }

    private func deleteItems(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { filteredGroceries[$0] }
        groceries.removeAll { item in
            itemsToDelete.contains(where: { $0.id == item.id })
        }
        onDelete()
    }
}

