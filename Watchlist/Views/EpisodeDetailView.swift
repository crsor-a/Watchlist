//
//  EpisodeDetailView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/20/26.
//

import SwiftUI

struct EpisodeDetailView: View {
    let episode: TMDbEpisode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                AsyncImage(url: episode.stillURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray4))
                        .frame(height: 180)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Season \(episode.seasonNumber), Episode \(episode.episodeNumber)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(episode.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)

                VStack(spacing: 0) {
                    if let airDate = episode.airDate {
                        InfoRow(label: "Air date", value: airDate)
                        Divider().padding(.leading, 12)
                    }
                    if let runtime = episode.runtime {
                        InfoRow(label: "Runtime", value: "\(runtime) min")
                        Divider().padding(.leading, 12)
                    }
                    if let score = episode.voteAverage {
                        InfoRow(label: "TMDb score", value: String(format: "%.1f", score))
                    }
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)

                if let overview = episode.overview, !overview.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Overview")
                            .font(.headline)
                            .padding(.horizontal)
                        Text(overview)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
