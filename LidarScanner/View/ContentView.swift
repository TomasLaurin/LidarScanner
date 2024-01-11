//
//  ContentView.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 29.12.2023.
//

import SwiftUI

// MARK: - Body
struct ContentView: View {
    @StateObject private var coordinator = Coordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                Spacer()
                Button {
                    coordinator.show(SavedObjectsView.self)
                } label: {
                    Text("Show saved files")
                }
                Spacer()
                Button {
                    coordinator.show(ScannerView.self)
                } label: {
                    Text("Scan a new object")
                }
                Spacer()
            }
            .navigationDestination(for: String.self) { id in
                if id == String(describing: SavedObjectsView.self) {
                    SavedObjectsView()
                } else if id == String(describing: ScannerView.self) {
                    ScannerView()
                }
            }
        }
        .environmentObject(coordinator)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
