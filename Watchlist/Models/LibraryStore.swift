//
//  LibraryStore.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/19/26.
//

import Foundation

class LibraryStore: ObservableObject {
    @Published var items: [MediaItem] = []

    private let storageKey = "watchlist_items"

    init() {
        load()
    }

    func add(_ item: MediaItem) {
        items.append(item)
        save()
    }

    func delete(_ item: MediaItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func update(_ item: MediaItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            save()
        }
    }

    func deleteAll() {
        items = []
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([MediaItem].self, from: data) {
            items = decoded
        }
    }

    var recentlyAdded: [MediaItem] {
        items.sorted { $0.dateAdded > $1.dateAdded }
            .prefix(3)
            .map { $0 }
    }

    var recentlyLiked: [MediaItem] {
        items.filter { $0.isLiked }
            .sorted { $0.dateAdded > $1.dateAdded }
            .prefix(3)
            .map { $0 }
    }

    var topFavorites: [MediaItem] {
        items.filter { $0.rating == 5 }
            .sorted { $0.dateAdded > $1.dateAdded }
            .prefix(10)
            .map { $0 }
    }
}
