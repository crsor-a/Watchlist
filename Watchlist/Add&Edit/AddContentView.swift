//
//  AddContentView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/20/26.
//

import SwiftUI

struct AddContentView: View {
    @EnvironmentObject var library: LibraryStore
    @Environment(\.dismiss) var dismiss

    @State private var searchText = ""
    @State private var showManualEntry = false
    @State private var searchResults: [TMDbSearchResult] = []
    @State private var isSearching = false
    @State private var searchTask: Task<Void, Never>? = nil

    // Manual entry fields
    @State private var manualTitle = ""
    @State private var manualType: MediaType = .movie
    @State private var manualYear = ""
    @State private var manualGenre = ""
    @State private var manualRuntime = ""
    @State private var manualRating = 0
    @State private var manualWatched = false
    @State private var manualLiked = false
    @State private var manualNotes = ""
    @State private var sendToTeam = true
    @State private var showContextFields = false
    @State private var manualDirector = ""
    @State private var manualCast = ""
    @State private var manualCountry = ""
    @State private var manualLanguage = ""

    var manualEntryIsValid: Bool {
        !manualTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {

                if !showManualEntry {
                    Section {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("Search the database...", text: $searchText)
                                .autocorrectionDisabled()
                        }
                    }

                    if isSearching {
                        Section {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    } else if !searchText.isEmpty {
                        Section(header: Text("Results")) {
                            if searchResults.isEmpty {
                                Text("No results found.")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            } else {
                                ForEach(searchResults) { result in
                                    Button(action: { addFromSearch(result) }) {
                                        HStack(spacing: 10) {
                                            AsyncImage(url: result.posterURL) { image in
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color(.systemGray4))
                                            }
                                            .frame(width: 36, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))

                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(result.displayTitle)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.primary)
                                                Text([result.displayYear.map { String($0) }, result.mediaType == "tv" ? "TV Show" : "Movie"]
                                                    .compactMap { $0 }
                                                    .joined(separator: " · "))
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            Spacer()
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Section {
                        Button(action: { withAnimation { showManualEntry = true } }) {
                            HStack(spacing: 10) {
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.title3)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Not appearing?")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.blue)
                                    Text("You can manually enter information about it instead.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                if showManualEntry {
                    Section(header: Text("Title")) {
                        TextField("Required", text: $manualTitle)
                    }

                    Section(header: Text("Details")) {
                        Picker("Type", selection: $manualType) {
                            Text("Movie").tag(MediaType.movie)
                            Text("TV Show").tag(MediaType.tvShow)
                        }
                        TextField("Year", text: $manualYear)
                            .keyboardType(.numberPad)
                        TextField("Genre", text: $manualGenre)
                        TextField("Runtime (minutes)", text: $manualRuntime)
                            .keyboardType(.numberPad)
                    }

                    Section(header: Text("Your take")) {
                        Toggle("Watched", isOn: $manualWatched)
                        HStack {
                            Text("Rating")
                            Spacer()
                            StarRatingView(
                                rating: manualRating,
                                interactive: true,
                                onRate: { manualRating = $0 }
                            )
                        }
                        Toggle("Liked", isOn: $manualLiked)
                    }

                    Section {
                        TextField("Notes (optional)", text: $manualNotes, axis: .vertical)
                            .lineLimit(3...6)
                    }

                    Section(footer: Text("Help us grow the database by sharing titles we might be missing.")) {
                        Toggle(isOn: $sendToTeam) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Send to Watchlist Team...")
                                    .font(.subheadline)
                                Text("Help us add missing titles")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Button(action: { withAnimation { showContextFields.toggle() } }) {
                            HStack {
                                Text("Help with context...")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .rotationEffect(.degrees(showContextFields ? 90 : 0))
                            }
                        }

                        if showContextFields {
                            TextField("Director", text: $manualDirector)
                                .padding(.leading, 8)
                            TextField("Cast", text: $manualCast)
                                .padding(.leading, 8)
                            TextField("Country", text: $manualCountry)
                                .padding(.leading, 8)
                            TextField("Language", text: $manualLanguage)
                                .padding(.leading, 8)
                        }
                    }

                    Section {
                        Button(action: { withAnimation { showManualEntry = false } }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Back to search")
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }

            }
            .navigationTitle(showManualEntry ? "Manual entry" : "Add content")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                if showManualEntry {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") { saveManualEntry() }
                            .disabled(!manualEntryIsValid)
                    }
                }
            }
            .onChange(of: searchText) { newValue in
                searchTask?.cancel()
                guard !newValue.isEmpty else {
                    searchResults = []
                    return
                }
                searchTask = Task {
                    try? await Task.sleep(nanoseconds: 350_000_000)
                    guard !Task.isCancelled else { return }
                    await performSearch(query: newValue)
                }
            }
        }
    }

    @MainActor
    func performSearch(query: String) async {
        isSearching = true
        do {
            searchResults = try await TMDbService.shared.search(query: query)
        } catch {
            searchResults = []
        }
        isSearching = false
    }

    func addFromSearch(_ result: TMDbSearchResult) {
        Task {
            do {
                var item: MediaItem
                if result.mediaType == "tv" {
                    let detail = try await TMDbService.shared.tvDetail(id: result.id)
                    item = MediaItem(
                        title: detail.name,
                        type: .tvShow,
                        year: detail.displayYear,
                        genre: detail.genreString.isEmpty ? nil : detail.genreString,
                        posterPath: detail.posterPath,
                        tmdbID: detail.id,
                        isManualEntry: false
                    )
                } else {
                    let detail = try await TMDbService.shared.movieDetail(id: result.id)
                    item = MediaItem(
                        title: detail.title,
                        type: .movie,
                        year: detail.displayYear,
                        genre: detail.genreString.isEmpty ? nil : detail.genreString,
                        runtime: detail.runtime,
                        posterPath: detail.posterPath,
                        tmdbID: detail.id,
                        isManualEntry: false
                    )
                }
                await MainActor.run {
                    library.add(item)
                    dismiss()
                }
            } catch {
                print("Failed to fetch detail: \(error)")
            }
        }
    }

    func saveManualEntry() {
        let item = MediaItem(
            title: manualTitle.trimmingCharacters(in: .whitespaces),
            type: manualType,
            year: Int(manualYear),
            genre: manualGenre.isEmpty ? nil : manualGenre,
            runtime: Int(manualRuntime),
            rating: manualRating,
            isLiked: manualLiked,
            isWatched: manualWatched,
            notes: manualNotes.isEmpty ? nil : manualNotes,
            isManualEntry: true
        )
        library.add(item)
        dismiss()
    }
}

struct AddContentView_Previews: PreviewProvider {
    static var previews: some View {
        AddContentView()
            .environmentObject(LibraryStore())
    }
}
