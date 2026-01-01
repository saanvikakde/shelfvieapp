//
//  OCRLine.swift
//  Shelfvie
//
//  Created by Saanvi Kakde on 1/1/26.
//


import Foundation

struct OCRLine: Identifiable {
    let id = UUID()
    let text: String
    var isSelected: Bool = false
}
