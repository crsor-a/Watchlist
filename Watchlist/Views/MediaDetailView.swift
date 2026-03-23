//
//  MediaDetailView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/19/26.
//

import SwiftUI

struct MediaDetailView: View {
    let item: MediaItem
    @State private var showTMDbDisclaimer = false
    @State private var navigateToEdit = false
    @State private var movieDetail: TMDbMovieDetail? = nil
    @State private var tvDetail: TMDbTVDetail? = nil
    @State private var isLoading = false
    @EnvironmentObject var library: LibraryStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Header
                HStack(alignment: .top, spacing: 12) {
                    AsyncImage(url: item.posterURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray4))
                    }
                    .frame(width: 80, height: 114)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.title)
                            .font(.title3)
                            .fontWeight(.semibold)

                        if let year = item.year {
                            Text("\(year) · \(item.type.rawValue)\(item.runtime != nil ? " · \(item.runtime!) min" : "")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        if let genre = item.genre {
                            Text(genre)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        StarRatingView(
                            rating: item.rating,
                            interactive: true,
                            onRate: { newRating in
                                var updated = item
                                updated.rating = newRating
                                library.update(updated)
                            }
                        )
                        .padding(.top, 4)

                        HStack(spacing: 6) {
                            if item.isWatched {
                                StatusPill(label: "Watched", color: .blue)
                            }
                            if item.isLiked {
                                StatusPill(label: "Liked", color: .pink)
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.horizontal)

                // TMDb metadata
                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .padding()
                } else if let movie = movieDetail {
                    TMDbMovieMetadataView(detail: movie)
                } else if let tv = tvDetail {
                    TMDbTVMetadataView(detail: tv, tmdbID: item.tmdbID)
                }

                // Local metadata
                VStack(spacing: 0) {
                    InfoRow(label: "Added", value: item.dateAdded.formatted(date: .abbreviated, time: .omitted))
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)

                // Notes
                if let notes = item.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Notes")
                            .font(.headline)
                            .padding(.horizontal)
                        Text(notes)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    if item.isManualEntry {
                        navigateToEdit = true
                    } else {
                        showTMDbDisclaimer = true
                    }
                }
            }
        }
        .alert("Edit auto-filled entry?", isPresented: $showTMDbDisclaimer) {
            Button("Edit anyway", role: .destructive) { navigateToEdit = true }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This entry was auto-filled. Editing will disconnect it from automatic updates.")
        }
        .navigationDestination(isPresented: $navigateToEdit) {
            EditMediaView(item: item)
                .environmentObject(library)
        }
        .task {
            await fetchTMDbDetail()
        }
    }

    func fetchTMDbDetail() async {
        guard let tmdbID = item.tmdbID else { return }
        isLoading = true
        do {
            if item.type == .movie {
                movieDetail = try await TMDbService.shared.movieDetail(id: tmdbID)
            } else {
                tvDetail = try await TMDbService.shared.tvDetail(id: tmdbID)
            }
        } catch {
            print("TMDb fetch failed: \(error)")
        }
        isLoading = false
    }
}

// MARK: - Movie metadata

struct TMDbMovieMetadataView: View {
    let detail: TMDbMovieDetail

    var body: some View {
        VStack(spacing: 0) {
            if let overview = detail.overview, !overview.isEmpty {
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

            VStack(spacing: 0) {
                if let score = detail.voteAverage {
                    InfoRow(label: "TMDb score", value: String(format: "%.1f", score))
                    Divider().padding(.leading, 12)
                }
                if let director = detail.director {
                    InfoRow(label: "Director", value: director)
                    Divider().padding(.leading, 12)
                }
                if !detail.castString.isEmpty {
                    InfoRow(label: "Cast", value: detail.castString)
                    Divider().padding(.leading, 12)
                }
                if let country = detail.originCountry?.first {
                    InfoRow(label: "Country", value: country)
                    Divider().padding(.leading, 12)
                }
                if let language = detail.originalLanguage {
                    InfoRow(label: "Language", value: language.uppercased())
                    Divider().padding(.leading, 12)
                }
                if let status = detail.status {
                    InfoRow(label: "Status", value: status)
                }
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}

// MARK: - TV metadata

struct TMDbTVMetadataView: View {
    let detail: TMDbTVDetail
    let tmdbID: Int?

    var body: some View {
        VStack(spacing: 0) {
            if let overview = detail.overview, !overview.isEmpty {
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

            VStack(spacing: 0) {
                if let score = detail.voteAverage {
                    InfoRow(label: "TMDb score", value: String(format: "%.1f", score))
                    Divider().padding(.leading, 12)
                }
                if let creator = detail.creator {
                    InfoRow(label: "Creator", value: creator)
                    Divider().padding(.leading, 12)
                }
                if !detail.castString.isEmpty {
                    InfoRow(label: "Cast", value: detail.castString)
                    Divider().padding(.leading, 12)
                }
                if let seasons = detail.numberOfSeasons {
                    InfoRow(label: "Seasons", value: "\(seasons)")
                    Divider().padding(.leading, 12)
                }
                if let episodes = detail.numberOfEpisodes {
                    InfoRow(label: "Episodes", value: "\(episodes)")
                    Divider().padding(.leading, 12)
                }
                if let language = detail.originalLanguage {
                    InfoRow(label: "Language", value: language.uppercased())
                    Divider().padding(.leading, 12)
                }
                if let status = detail.status {
                    InfoRow(label: "Status", value: status)
                }
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)

            if let tmdbID = tmdbID {
                NavigationLink(destination: SeasonListView(tvID: tmdbID, detail: detail)) {
                    HStack {
                        Text("Episode guide")
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
        }
    }
}

struct StatusPill: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(999)
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
    }
}

struct MediaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MediaDetailView(item: MediaItem(
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
}
