//
//  GroceryListView.swift
//  Shelfvie
//
//  Created by Saanvi Kakde on 12/17/25.
//

import SwiftUI

struct GroceryListView: View {

    let title: String
    let groceries: [GroceryItem]

    var body: some View {
        List {
            ForEach(groceries.sorted(by: { $0.expirationDate < $1.expirationDate })) { item in
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)

                    Text("Expires \(item.expirationDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(title)
    }
}

