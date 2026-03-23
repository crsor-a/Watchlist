//
//  WatchlistApp.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/18/26.
//

import SwiftUI

@main
struct WatchlistApp: App {
    @StateObject private var libraryStore = LibraryStore()
    @StateObject private var userProfile = UserProfile()
    @AppStorage("colorSchemePreference") private var colorSchemePreference: String = "Follow iOS Setting"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(libraryStore)
                .environmentObject(userProfile)
                .preferredColorScheme(
                    colorSchemePreference == "Dark" ? .dark :
                    colorSchemePreference == "Light" ? .light : nil
                )
        }
    }
}
