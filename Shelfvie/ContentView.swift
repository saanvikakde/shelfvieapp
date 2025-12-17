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

    private let groceriesKey = "savedGroceries"

    var body: some View {
        TabView {

            NavigationStack {
                GroceryListView(
                    title: "Fridge",
                    groceries: groceries.filter { $0.location == .fridge }
                )
                .toolbar {
                    addButton
                }
            }
            .tabItem {
                Label("Fridge", systemImage: "refrigerator")
            }

            NavigationStack {
                GroceryListView(
                    title: "Freezer",
                    groceries: groceries.filter { $0.location == .freezer }
                )
                .toolbar {
                    addButton
                }
            }
            .tabItem {
                Label("Freezer", systemImage: "snowflake")
            }

            NavigationStack {
                GroceryListView(
                    title: "Pantry",
                    groceries: groceries.filter { $0.location == .pantry }
                )
                .toolbar {
                    addButton
                }
            }
            .tabItem {
                Label("Pantry", systemImage: "cabinet")
            }
        }
        .sheet(isPresented: $showingAddGrocery) {
            AddGroceryView { newItem in
                groceries.append(newItem)
                saveGroceries()
            }
        }
        .onAppear {
            loadGroceries()
        }
    }

    // MARK: - Reusable Add Button
    private var addButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showingAddGrocery = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }

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
