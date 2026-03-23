//
//  MeView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/18/26.
//

import SwiftUI

struct MeView: View {
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var library: LibraryStore
    @State private var showSettings = false
    @AppStorage("colorSchemePreference") private var colorSchemePreference: String = "Follow iOS Setting"
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 72, height: 72)
                                Text(profile.name.isEmpty
                                     ? "?"
                                     : String(profile.name.prefix(1)).uppercased())
                                .font(.largeTitle)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            }
                            if !profile.name.isEmpty {
                                Text(profile.name)
                                    .font(.headline)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Profile")) {
                    TextField("Your name", text: $profile.name)
                }
                
                Section(header: Text("Library stats")) {
                    StatRow(label: "Total entries", value: "\(library.items.count)")
                    StatRow(label: "Movies", value: "\(library.items.filter { $0.type == .movie }.count)")
                    StatRow(label: "TV shows", value: "\(library.items.filter { $0.type == .tvShow }.count)")
                    StatRow(label: "Watched", value: "\(library.items.filter { $0.isWatched }.count)")
                    StatRow(label: "Unwatched", value: "\(library.items.filter { !$0.isWatched }.count)")
                    StatRow(label: "Liked", value: "\(library.items.filter { $0.isLiked }.count)")
                }
                
            }
            .navigationTitle("Me")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(library)
                    .environmentObject(profile)
                    .preferredColorScheme(
                        colorSchemePreference == "Dark" ? .dark :
                            colorSchemePreference == "Light" ? .light : nil
                    )
            }
        }
    }
    
    struct StatRow: View {
        let label: String
        let value: String
        
        var body: some View {
            HStack {
                Text(label)
                Spacer()
                Text(value)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    struct MeView_Previews: PreviewProvider {
        static var previews: some View {
            let store = LibraryStore()
            store.add(MediaItem(title: "Dune: Part Two", type: .movie, year: 2024, genre: "Sci-Fi", rating: 5, isWatched: true))
            store.add(MediaItem(title: "Severance", type: .tvShow, year: 2022, genre: "Drama", rating: 4, isLiked: true, isWatched: true))
            return MeView()
                .environmentObject(store)
                .environmentObject(UserProfile())
        }
    }
}
