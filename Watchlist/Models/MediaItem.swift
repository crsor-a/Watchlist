//
//  MediaItem.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/19/26.
//

import Foundation

enum MediaType: String, Codable {
    case movie = "Movie"
    case tvShow = "TV Show"
}

struct MediaItem: Identifiable, Codable {
    var id: UUID
    var title: String
    var type: MediaType
    var year: Int?
    var genre: String?
    var runtime: Int?
    var posterPath: String?
    var tmdbID: Int?
    var rating: Int
    var isLiked: Bool
    var isWatched: Bool
    var dateAdded: Date
    var notes: String?
    var isManualEntry: Bool

    init(
        title: String,
        type: MediaType,
        year: Int? = nil,
        genre: String? = nil,
        runtime: Int? = nil,
        posterPath: String? = nil,
        tmdbID: Int? = nil,
        rating: Int = 0,
        isLiked: Bool = false,
        isWatched: Bool = false,
        notes: String? = nil,
        isManualEntry: Bool = false
    ) {
        self.id = UUID()
        self.title = title
        self.type = type
        self.year = year
        self.genre = genre
        self.runtime = runtime
        self.posterPath = posterPath
        self.tmdbID = tmdbID
        self.rating = rating
        self.isLiked = isLiked
        self.isWatched = isWatched
        self.dateAdded = Date()
        self.notes = notes
        self.isManualEntry = isManualEntry
    }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "\(TMDbConfig.imageBaseURL)\(path)")
    }
}
