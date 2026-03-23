//
//  EpisodeListView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/20/26.
//

import SwiftUI

struct EpisodeListView: View {
    let tvID: Int
    let seasonNumber: Int

    @State private var season: TMDbSeason? = nil
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if let season = season {
                List(season.episodes) { episode in
                    NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("E\(episode.episodeNumber) — \(episode.name)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .lineLimit(1)
                            if let airDate = episode.airDate {
                                Text(airDate)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Season \(seasonNumber)")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                season = try await TMDbService.shared.season(tvID: tvID, seasonNumber: seasonNumber)
            } catch {
                print("Failed to load season: \(error)")
            }
            isLoading = false
        }
    }
}
