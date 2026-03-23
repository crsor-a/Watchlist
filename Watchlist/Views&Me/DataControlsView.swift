//
//  DataControlsView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/20/26.
//

import SwiftUI

struct DataControlsView: View {
    @EnvironmentObject var library: LibraryStore
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteConfirmation = false
    @State private var showExportSheet = false
    @State private var exportedJSON: String = ""
    @EnvironmentObject var profile: UserProfile

    var body: some View {
        NavigationStack {
            Form {

                Section(header: Text("Export & Import")) {
                    Button(action: exportData) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export library data")
                        }
                    }
                    Button(action: { showExportSheet = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Import library data")
                        }
                    }
                }

                Section(
                    header: Text("Danger zone"),
                    footer: Text("Deleting your data is permanent and cannot be undone.")
                ) {
                    Button(role: .destructive, action: { showDeleteConfirmation = true }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete data and account")
                        }
                    }
                }

            }
            .navigationTitle("Data controls")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Delete all data?", isPresented: $showDeleteConfirmation) {
                Button("Delete everything", role: .destructive) {
                    library.deleteAll()
                    profile.name = ""
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete your entire library and profile. This action is irreversible and cannot be undone.")
            }
            .sheet(isPresented: $showExportSheet) {
                ShareSheet(activityItems: [exportedJSON])
            }
        }
    }

    func exportData() {
        if let encoded = try? JSONEncoder().encode(library.items),
           let json = String(data: encoded, encoding: .utf8) {
            exportedJSON = json
            showExportSheet = true
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct DataControlsView_Previews: PreviewProvider {
    static var previews: some View {
        DataControlsView()
            .environmentObject(LibraryStore())
    }
}
