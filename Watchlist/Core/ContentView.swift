//
//  ContentView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/18/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "star.fill")
                }

            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "film.fill")
                }
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LibraryStore())
            .environmentObject(UserProfile())
    }
}
