//
//  ReceiptScannerView.swift
//  Shelfvie
//
//  Created by Saanvi Kakde on 12/31/25.
//

import SwiftUI
import Vision
import UIKit

struct ReceiptScannerView: View {

    @State private var pickerSource: ImagePicker.Source? = nil
    @State private var ocrLines: [OCRLine] = []
    @State private var errorMessage: String? = nil

    /// Callback to send confirmed items back to ContentView
    var onItemsConfirmed: ([String]) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                // MARK: - Status / Errors
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                // MARK: - OCR Results
                if !ocrLines.isEmpty {
                    List {
                        ForEach($ocrLines) { $line in
                            HStack {
                                Text(line.text)

                                Spacer()

                                if line.isSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                line.isSelected.toggle()
                            }
                        }
                    }
                } else if errorMessage == nil {
                    Text("Scan or upload a receipt to detect grocery items.")
                        .foregroundColor(.secondary)
                        .padding()
                }

                // MARK: - Add Selected Items Button
                if ocrLines.contains(where: { $0.isSelected }) {
                    Button {
                        addSelectedItems()
                    } label: {
                        Text("Add Selected Items")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

                Spacer()

                // MARK: - Actions
                HStack(spacing: 20) {
                    Button {
                        pickerSource = .camera
                    } label: {
                        Label("Scan Receipt", systemImage: "camera")
                    }

                    Button {
                        pickerSource = .photoLibrary
                    } label: {
                        Label("Upload Image", systemImage: "photo")
                    }
                }
                .font(.headline)
            }
            .padding()
            .navigationTitle("Receipt Scan")
            .sheet(item: $pickerSource) { source in
                ImagePicker(source: source) { image in
                    recognizeText(from: image)
                    pickerSource = nil
                }
            }
        }
    }

    // MARK: - OCR Logic
    private func recognizeText(from image: UIImage) {
        errorMessage = nil
        ocrLines = []

        guard let cgImage = image.cgImage else {
            errorMessage = "Could not process image."
            return
        }

        let request = VNRecognizeTextRequest { request, _ in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                DispatchQueue.main.async {
                    errorMessage = "No text detected."
                }
                return
            }

            let rawLines = observations
                .compactMap { $0.topCandidates(1).first?.string }

            let filtered = filterGroceryLikeLines(rawLines)

            DispatchQueue.main.async {
                if filtered.isEmpty {
                    errorMessage = "No readable grocery items found. Try a clearer photo."
                } else {
                    ocrLines = filtered.map { OCRLine(text: $0) }
                }
            }
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([request])
    }

    // MARK: - Add Selected Items
    private func addSelectedItems() {
        let selectedItems = ocrLines
            .filter { $0.isSelected }
            .map { $0.text }

        onItemsConfirmed(selectedItems)

        // Reset state after adding
        ocrLines = []
        errorMessage = nil
    }

    // MARK: - Heuristic Filtering
    private func filterGroceryLikeLines(_ lines: [String]) -> [String] {
        lines.filter { line in
            let lower = line.lowercased()

            // Ignore prices, totals, payments, etc.
            let ignoredKeywords = [
                "total", "subtotal", "tax", "$",
                "visa", "mastercard", "change", "balance"
            ]
            if ignoredKeywords.contains(where: lower.contains) {
                return false
            }

            // Must contain letters
            let hasLetters = lower.range(of: "[a-z]", options: .regularExpression) != nil

            // Short-ish lines are more likely item names
            let reasonableLength = line.count <= 30

            return hasLetters && reasonableLength
        }
    }
}

