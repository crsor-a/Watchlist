//
//  HomeView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/18/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var library: LibraryStore
    @EnvironmentObject var profile: UserProfile
    @State private var showAddContent = false
    @State private var topMovies: [TMDbSearchResult] = []
    @State private var topShows: [TMDbSearchResult] = []

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<5: return "Good evening"
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Recently Added
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recently Added")
                            .font(.headline)

                        if library.recentlyAdded.isEmpty {
                            Text("Nothing added yet. Tap Add New Content to get started.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(library.recentlyAdded) { item in
                                    NavigationLink(destination: MediaDetailView(item: item).environmentObject(library)) {
                                        MediaRowView(item: item)
                                    }
                                    .buttonStyle(.plain)
                                    if item.id != library.recentlyAdded.last?.id {
                                        Divider().padding(.leading, 56)
                                    }
                                }
                            }
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    }

                    // Recently Liked
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recently Liked")
                            .font(.headline)

                        if library.recentlyLiked.isEmpty {
                            Text("Like an entry in your library to see it here.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(library.recentlyLiked) { item in
                                    NavigationLink(destination: MediaDetailView(item: item).environmentObject(library)) {
                                        MediaRowView(item: item)
                                    }
                                    .buttonStyle(.plain)
                                    if item.id != library.recentlyLiked.last?.id {
                                        Divider().padding(.leading, 56)
                                    }
                                }
                            }
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    }

                    // Top 10 Favorites
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Top 10 Favorites")
                            .font(.headline)

                        if library.topFavorites.isEmpty {
                            Text("Rate something 5 stars to build your favorites.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(Array(library.topFavorites.enumerated()), id: \.element.id) { index, item in
                                    NavigationLink(destination: MediaDetailView(item: item).environmentObject(library)) {
                                        MediaRowView(item: item, rank: index + 1)
                                    }
                                    .buttonStyle(.plain)
                                    if item.id != library.topFavorites.last?.id {
                                        Divider().padding(.leading, 56)
                                    }
                                }
                            }
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    }

                    // Top 10 on TMDb — Movies
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Top 10 on TMDb")
                                .font(.headline)
                            Text("Movies")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        if topMovies.isEmpty {
                            Text("Loading...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(Array(topMovies.prefix(10).enumerated()), id: \.element.id) { index, movie in
                                    HStack(spacing: 10) {
                                        Text("\(index + 1)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .frame(width: 20, alignment: .center)

                                        AsyncImage(url: movie.posterURL) { image in
                                            image.resizable().aspectRatio(contentMode: .fill)
                                        } placeholder: {
                                            RoundedRectangle(cornerRadius: 5).fill(Color(.systemGray4))
                                        }
                                        .frame(width: 40, height: 56)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(movie.displayTitle)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .lineLimit(1)
                                            if let year = movie.displayYear {
                                                Text(String(year))
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            if let score = movie.voteAverage {
                                                Text(String(format: "%.1f TMDb", score))
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 9)

                                    if index < min(9, topMovies.count - 1) {
                                        Divider().padding(.leading, 56)
                                    }
                                }
                            }
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    }

                    // Top 10 on TMDb — TV Shows
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Top 10 on TMDb")
                                .font(.headline)
                            Text("TV Shows")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        if topShows.isEmpty {
                            Text("Loading...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(Array(topShows.prefix(10).enumerated()), id: \.element.id) { index, show in
                                    HStack(spacing: 10) {
                                        Text("\(index + 1)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .frame(width: 20, alignment: .center)

                                        AsyncImage(url: show.posterURL) { image in
                                            image.resizable().aspectRatio(contentMode: .fill)
                                        } placeholder: {
                                            RoundedRectangle(cornerRadius: 5).fill(Color(.systemGray4))
                                        }
                                        .frame(width: 40, height: 56)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(show.displayTitle)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .lineLimit(1)
                                            if let year = show.displayYear {
                                                Text(String(year))
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            if let score = show.voteAverage {
                                                Text(String(format: "%.1f TMDb", score))
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 9)

                                    if index < min(9, topShows.count - 1) {
                                        Divider().padding(.leading, 56)
                                    }
                                }
                            }
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    }

                }
                .padding(.horizontal)
            }
            .navigationTitle(
                profile.name.isEmpty
                    ? "\(greeting)!"
                    : "\(greeting), \(profile.name)!"
            )
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showAddContent = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle")
                            Text("Add New Content...")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddContent) {
                AddContentView()
                    .environmentObject(library)
            }
            .task {
                do {
                    topMovies = try await TMDbService.shared.topRatedMovies()
                    topShows = try await TMDbService.shared.topRatedTV()
                } catch {
                    print("Failed to load top rated: \(error)")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let store = LibraryStore()
        store.add(MediaItem(title: "Dune: Part Two", type: .movie, year: 2024, genre: "Sci-Fi", rating: 5, isLiked: true, isWatched: true))
        store.add(MediaItem(title: "Severance", type: .tvShow, year: 2022, genre: "Drama", rating: 4, isLiked: true, isWatched: true))
        store.add(MediaItem(title: "The Bear", type: .tvShow, year: 2022, genre: "Drama", rating: 4, isWatched: true))

        return HomeView()
            .environmentObject(store)
            .environmentObject(UserProfile())
    }
}
