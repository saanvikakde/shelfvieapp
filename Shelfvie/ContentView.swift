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
        NavigationStack {
            List {
                ForEach(groceries.sorted(by: { $0.expirationDate < $1.expirationDate })) { item in
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)

                        Text("\(item.location.rawValue) • Expires \(item.expirationDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Shelfvie")
            .toolbar {
                Button {
                    showingAddGrocery = true
                } label: {
                    Image(systemName: "plus")
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
