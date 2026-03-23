//
//  TMDbModels.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/20/26.
//

import Foundation

// MARK: - Search

struct TMDbSearchResponse: Codable {
    let results: [TMDbSearchResult]
}

struct TMDbSearchResult: Codable, Identifiable {
    let id: Int
    let mediaType: String?
    let title: String?
    let name: String?
    let overview: String?
    let posterPath: String?
    let voteAverage: Double?
    let releaseDate: String?
    let firstAirDate: String?
    let genreIDs: [Int]?

    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case title
        case name
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case genreIDs = "genre_ids"
    }

    var displayTitle: String {
        title ?? name ?? "Unknown"
    }

    var displayYear: Int? {
        let dateString = releaseDate ?? firstAirDate ?? ""
        return Int(dateString.prefix(4))
    }

    var mediaTypeEnum: MediaType {
        mediaType == "tv" ? .tvShow : .movie
    }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "\(TMDbConfig.imageBaseURL)\(path)")
    }
}

// MARK: - Movie detail

struct TMDbMovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double?
    let genres: [TMDbGenre]?
    let credits: TMDbCredits?
    let originCountry: [String]?
    let originalLanguage: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, credits, status
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
    }

    var displayYear: Int? { Int(releaseDate?.prefix(4) ?? "") }
    var genreString: String { genres?.map { $0.name }.joined(separator: ", ") ?? "" }
    var director: String? { credits?.crew.first(where: { $0.job == "Director" })?.name }
    var castString: String { credits?.cast.prefix(5).map { $0.name }.joined(separator: ", ") ?? "" }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "\(TMDbConfig.imageBaseURL)\(path)")
    }
}

// MARK: - TV detail

struct TMDbTVDetail: Codable {
    let id: Int
    let name: String
    let overview: String?
    let posterPath: String?
    let firstAirDate: String?
    let voteAverage: Double?
    let genres: [TMDbGenre]?
    let credits: TMDbCredits?
    let numberOfSeasons: Int?
    let numberOfEpisodes: Int?
    let originalLanguage: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id, name, overview, genres, credits, status
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case numberOfSeasons = "number_of_seasons"
        case numberOfEpisodes = "number_of_episodes"
        case originalLanguage = "original_language"
    }

    var displayYear: Int? { Int(firstAirDate?.prefix(4) ?? "") }
    var genreString: String { genres?.map { $0.name }.joined(separator: ", ") ?? "" }
    var creator: String? { credits?.crew.first(where: { $0.job == "Creator" })?.name }
    var castString: String { credits?.cast.prefix(5).map { $0.name }.joined(separator: ", ") ?? "" }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "\(TMDbConfig.imageBaseURL)\(path)")
    }
}

// MARK: - Shared

struct TMDbGenre: Codable {
    let id: Int
    let name: String
}

struct TMDbCredits: Codable {
    let cast: [TMDbCastMember]
    let crew: [TMDbCrewMember]
}

struct TMDbCastMember: Codable {
    let name: String
    let character: String?
}

struct TMDbCrewMember: Codable {
    let name: String
    let job: String
}

// MARK: - Season

struct TMDbSeason: Codable {
    let id: Int
    let name: String
    let seasonNumber: Int
    let episodes: [TMDbEpisode]

    enum CodingKeys: String, CodingKey {
        case id, name, episodes
        case seasonNumber = "season_number"
    }
}

struct TMDbEpisode: Codable, Identifiable {
    let id: Int
    let name: String
    let overview: String?
    let episodeNumber: Int
    let seasonNumber: Int
    let airDate: String?
    let runtime: Int?
    let stillPath: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, overview, runtime
        case episodeNumber = "episode_number"
        case seasonNumber = "season_number"
        case airDate = "air_date"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
    }

    var stillURL: URL? {
        guard let path = stillPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
    }
}
