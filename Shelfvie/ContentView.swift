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
                }
            }
        }
    }
}
