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

    @State private var showingPicker = false
    @State private var pickerSource: ImagePicker.Source = .camera
    @State private var scannedText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                if scannedText.isEmpty {
                    Text("Scan or upload a grocery receipt to extract text.")
                        .foregroundColor(.secondary)
                } else {
                    ScrollView {
                        Text(scannedText)
                            .padding()
                    }
                }

                HStack(spacing: 20) {
                    Button {
                        pickerSource = .camera
                        showingPicker = true
                    } label: {
                        Label("Scan Receipt", systemImage: "camera")
                    }

                    Button {
                        pickerSource = .photoLibrary
                        showingPicker = true
                    } label: {
                        Label("Upload Image", systemImage: "photo")
                    }
                }
                .font(.headline)
            }
            .padding()
            .navigationTitle("Receipt Scan")
            .sheet(isPresented: $showingPicker) {
                ImagePicker(source: pickerSource) { image in
                    recognizeText(from: image)
                }
            }
        }
    }

    private func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let request = VNRecognizeTextRequest { request, _ in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

            let text = observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")

            DispatchQueue.main.async {
                scannedText = text
            }
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([request])
    }
}
