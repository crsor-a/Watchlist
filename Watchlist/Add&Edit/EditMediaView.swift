//
//  EditMediaView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/20/26.
//

import SwiftUI

struct EditMediaView: View {
    @EnvironmentObject var library: LibraryStore
    @Environment(\.dismiss) var dismiss

    let item: MediaItem

    @State private var title: String
    @State private var type: MediaType
    @State private var year: String
    @State private var genre: String
    @State private var runtime: String
    @State private var rating: Int
    @State private var isWatched: Bool
    @State private var isLiked: Bool
    @State private var notes: String
    @State private var showDeleteConfirmation = false

    init(item: MediaItem) {
        self.item = item
        _title = State(initialValue: item.title)
        _type = State(initialValue: item.type)
        _year = State(initialValue: item.year.map { String($0) } ?? "")
        _genre = State(initialValue: item.genre ?? "")
        _runtime = State(initialValue: item.runtime.map { String($0) } ?? "")
        _rating = State(initialValue: item.rating)
        _isWatched = State(initialValue: item.isWatched)
        _isLiked = State(initialValue: item.isLiked)
        _notes = State(initialValue: item.notes ?? "")
    }

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {

                Section(header: Text("Title")) {
                    TextField("Required", text: $title)
                }

                Section(header: Text("Details")) {
                    Picker("Type", selection: $type) {
                        Text("Movie").tag(MediaType.movie)
                        Text("TV Show").tag(MediaType.tvShow)
                    }
                    TextField("Year", text: $year)
                        .keyboardType(.numberPad)
                    TextField("Genre", text: $genre)
                    TextField("Runtime (minutes)", text: $runtime)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Your take")) {
                    Toggle("Watched", isOn: $isWatched)
                    HStack {
                        Text("Rating")
                        Spacer()
                        StarRatingView(
                            rating: rating,
                            interactive: true,
                            onRate: { rating = $0 }
                        )
                    }
                    Toggle("Liked", isOn: $isLiked)
                }

                Section {
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section {
                    Button(role: .destructive, action: { showDeleteConfirmation = true }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete entry")
                        }
                    }
                }

            }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(!isValid)
                }
            }
            .alert("Delete entry?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    library.delete(item)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently remove \"\(item.title)\" from your library.")
            }
        }
    }

    func saveChanges() {
        var updated = item
        updated.title = title.trimmingCharacters(in: .whitespaces)
        updated.type = type
        updated.year = Int(year)
        updated.genre = genre.isEmpty ? nil : genre
        updated.runtime = Int(runtime)
        updated.rating = rating
        updated.isWatched = isWatched
        updated.isLiked = isLiked
        updated.notes = notes.isEmpty ? nil : notes
        library.update(updated)
        dismiss()
    }
}

struct EditMediaView_Previews: PreviewProvider {
    static var previews: some View {
        EditMediaView(item: MediaItem(
            title: "Dune: Part Two",
            type: .movie,
            year: 2024,
            genre: "Sci-Fi",
            runtime: 166,
            rating: 5,
            isLiked: true,
            isWatched: true,
            notes: "Rewatch before Dune 3 drops."
        ))
        .environmentObject(LibraryStore())
    }
}
