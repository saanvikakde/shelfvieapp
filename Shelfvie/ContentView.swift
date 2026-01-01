//
//  ContentView.swift
//  Shelfvie
//
//  Created by Saanvi Kakde on 12/13/25.
//

import SwiftUI

struct ContentView: View {

    @State private var groceries: [GroceryItem] = []
    @State private var showingAddGrocery = false
    @State private var editingItem: GroceryItem? = nil

    private let groceriesKey = "savedGroceries"

    var body: some View {
        TabView {

            fridgeTab
            freezerTab
            pantryTab
            ocrTab
        }
        .sheet(isPresented: $showingAddGrocery) {
            AddGroceryView { newItem in
                groceries.append(newItem)
                saveGroceries()
            }
        }
        .sheet(item: $editingItem) { item in
            AddGroceryView(editingItem: item) { updatedItem in
                if let index = groceries.firstIndex(where: { $0.id == updatedItem.id }) {
                    groceries[index] = updatedItem
                    saveGroceries()
                }
            }
        }
        .onAppear {
            loadGroceries()
        }
    }

    // MARK: - Tabs

    private var fridgeTab: some View {
        NavigationStack {
            GroceryListView(
                title: "Fridge",
                groceries: $groceries,
                location: .fridge,
                onDelete: saveGroceries,
                onEdit: { editingItem = $0 }
            )
            .toolbar { addButton }
        }
        .tabItem {
            Label("Fridge", systemImage: "refrigerator")
        }
    }

    private var freezerTab: some View {
        NavigationStack {
            GroceryListView(
                title: "Freezer",
                groceries: $groceries,
                location: .freezer,
                onDelete: saveGroceries,
                onEdit: { editingItem = $0 }
            )
            .toolbar { addButton }
        }
        .tabItem {
            Label("Freezer", systemImage: "snowflake")
        }
    }

    private var pantryTab: some View {
        NavigationStack {
            GroceryListView(
                title: "Pantry",
                groceries: $groceries,
                location: .pantry,
                onDelete: saveGroceries,
                onEdit: { editingItem = $0 }
            )
            .toolbar { addButton }
        }
        .tabItem {
            Label("Pantry", systemImage: "cabinet")
        }
    }

    private var ocrTab: some View {
        NavigationStack {
            ReceiptScannerView { scannedItems in
                let newGroceries = scannedItems.map {
                    GroceryItem(
                        name: $0,
                        expirationDate: Date(), // temporary
                        location: .pantry       // default for now
                    )
                }

                groceries.append(contentsOf: newGroceries)
                saveGroceries()
            }
        }
        .tabItem {
            Label("Scan", systemImage: "doc.text.viewfinder")
        }
    }

    // MARK: - Add Button

    private var addButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showingAddGrocery = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }

    // MARK: - Persistence

    private func saveGroceries() {
        if let data = try? JSONEncoder().encode(groceries) {
            UserDefaults.standard.set(data, forKey: groceriesKey)
        }
    }

    private func loadGroceries() {
        if let data = UserDefaults.standard.data(forKey: groceriesKey),
           let savedGroceries = try? JSONDecoder().decode([GroceryItem].self, from: data) {
            groceries = savedGroceries
        }
    }
}
