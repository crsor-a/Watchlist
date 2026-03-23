//
//  LibraryView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/18/26.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var library: LibraryStore

    @State private var searchText = ""
    @State private var selectedFilter: FilterOption = .all
    @State private var selectedSort: SortOption = .dateAddedNewest

    enum FilterOption {
        case all, movies, tvShows, unwatched
    }

    enum SortOption {
        case dateAddedNewest, dateAddedOldest, starRating, unwatchedFirst
    }

    var filteredItems: [MediaItem] {
        var items = library.items

        switch selectedFilter {
        case .all: break
        case .movies: items = items.filter { $0.type == .movie }
        case .tvShows: items = items.filter { $0.type == .tvShow }
        case .unwatched: items = items.filter { !$0.isWatched }
        }

        if !searchText.isEmpty {
            items = items.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                ($0.genre?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                ($0.year.map { String($0).contains(searchText) } ?? false)
            }
        }

        switch selectedSort {
        case .dateAddedNewest: items.sort { $0.dateAdded > $1.dateAdded }
        case .dateAddedOldest: items.sort { $0.dateAdded < $1.dateAdded }
        case .starRating: items.sort { $0.rating > $1.rating }
        case .unwatchedFirst: items.sort { !$0.isWatched && $1.isWatched }
        }

        return items
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // Filter pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterPill(title: "All", isSelected: selectedFilter == .all) {
                            selectedFilter = .all
                        }
                        FilterPill(title: "Movies", isSelected: selectedFilter == .movies) {
                            selectedFilter = .movies
                        }
                        FilterPill(title: "TV Shows", isSelected: selectedFilter == .tvShows) {
                            selectedFilter = .tvShows
                        }
                        FilterPill(title: "Unwatched", isSelected: selectedFilter == .unwatched) {
                            selectedFilter = .unwatched
                        }

                        Divider().frame(height: 20)

                        Menu {
                            Button("Star rating") { selectedSort = .starRating }
                            Button("Date added: newest") { selectedSort = .dateAddedNewest }
                            Button("Date added: oldest") { selectedSort = .dateAddedOldest }
                            Button("Unwatched first") { selectedSort = .unwatchedFirst }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .font(.caption)
                                Text("Filter...")
                                    .font(.subheadline)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(999)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }

                Divider()

                // List
                if filteredItems.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Text(library.items.isEmpty
                            ? "Your library is empty.\nTap Add New Content to get started."
                            : "No results found.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(filteredItems) { item in
                            NavigationLink(destination: MediaDetailView(item: item)) {
                                MediaRowView(item: item)
                            }
                            .listRowInsets(EdgeInsets())
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Type title, year, genre, cast...")
        }
    }
}

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.secondarySystemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(999)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        let store = LibraryStore()
        store.add(MediaItem(title: "Dune: Part Two", type: .movie, year: 2024, genre: "Sci-Fi", rating: 5, isWatched: true))
        store.add(MediaItem(title: "Severance", type: .tvShow, year: 2022, genre: "Drama", rating: 4, isLiked: true, isWatched: true))
        store.add(MediaItem(title: "Oppenheimer", type: .movie, year: 2023, genre: "Drama", isManualEntry: true))
        return LibraryView()
            .environmentObject(store)
    }
}
