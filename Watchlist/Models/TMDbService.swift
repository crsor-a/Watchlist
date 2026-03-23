//
//  TMDbService.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/20/26.
//

import Foundation

class TMDbService {
    static let shared = TMDbService()

    private var headers: [String: String] {
        [
            "Authorization": "Bearer \(TMDbConfig.readToken)",
            "Content-Type": "application/json"
        ]
    }

    // MARK: - Search

    func search(query: String) async throws -> [TMDbSearchResult] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = URL(string: "\(TMDbConfig.baseURL)/search/multi?query=\(encoded)&include_adult=false")!
        let data = try await fetch(url: url)
        let response = try JSONDecoder().decode(TMDbSearchResponse.self, from: data)
        return response.results.filter { $0.mediaType == "movie" || $0.mediaType == "tv" }
    }

    // MARK: - Movie detail

    func movieDetail(id: Int) async throws -> TMDbMovieDetail {
        let url = URL(string: "\(TMDbConfig.baseURL)/movie/\(id)?append_to_response=credits")!
        let data = try await fetch(url: url)
        return try JSONDecoder().decode(TMDbMovieDetail.self, from: data)
    }

    // MARK: - TV detail

    func tvDetail(id: Int) async throws -> TMDbTVDetail {
        let url = URL(string: "\(TMDbConfig.baseURL)/tv/\(id)?append_to_response=credits")!
        let data = try await fetch(url: url)
        return try JSONDecoder().decode(TMDbTVDetail.self, from: data)
    }

    // MARK: - Top rated movies

    func topRatedMovies() async throws -> [TMDbSearchResult] {
        let url = URL(string: "\(TMDbConfig.baseURL)/movie/top_rated")!
        let data = try await fetch(url: url)
        let response = try JSONDecoder().decode(TMDbSearchResponse.self, from: data)
        return response.results
    }

    // MARK: - Top rated TV

    func topRatedTV() async throws -> [TMDbSearchResult] {
        let url = URL(string: "\(TMDbConfig.baseURL)/tv/top_rated")!
        let data = try await fetch(url: url)
        let response = try JSONDecoder().decode(TMDbSearchResponse.self, from: data)
        return response.results
    }

    // MARK: - Seasons

    func season(tvID: Int, seasonNumber: Int) async throws -> TMDbSeason {
        let url = URL(string: "\(TMDbConfig.baseURL)/tv/\(tvID)/season/\(seasonNumber)")!
        let data = try await fetch(url: url)
        return try JSONDecoder().decode(TMDbSeason.self, from: data)
    }

    // MARK: - Private fetch

    private func fetch(url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw TMDbError.badResponse
        }
        return data
    }
}

enum TMDbError: Error {
    case badResponse
    case decodingFailed
}
