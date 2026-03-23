//
//  ClaudesCornerView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/20/26.
//

import SwiftUI

struct ClaudesCornerView: View {

    let buildLog: [(date: String, entry: String)] = [
        ("Mar 18, 2026", "Project started. Decided on TabView with Home, Library, and Me tabs. Established UserProfile as a shared ObservableObject injected via environment."),
        ("Mar 18, 2026", "Chose SwiftData for persistence — then immediately hit the Xcode 14.2 ceiling. SwiftData requires iOS 17. Pivoted to Codable + UserDefaults. MediaItem became a struct."),
        ("Mar 18, 2026", "TMDb chosen as the data API after ruling out IMDb (no free public API) and RapidAPI wrappers (unreliable). TMDb covers search, metadata, posters, cast, top rated — everything the app needs under one free key."),
        ("Mar 19, 2026", "Designed the Add Content sheet with two entry paths: TMDb search with live preview, and manual entry. Manual entries flag isManualEntry: true, which triggers a disclaimer on edit."),
        ("Mar 19, 2026", "Built HomeView, LibraryView, MediaDetailView, MeView, SettingsView, DataControlsView, AboutView. Rating scale settled at 5 stars — Letterboxd logic, faster to tap, sufficient granularity."),
        ("Mar 19, 2026", "Claude's Corner added. Rauf's idea. Claude's first permanent residence in an iOS app."),
        ("Mar 20, 2026", "TMDb integration completed. Live search, auto-fill, poster images, full metadata in detail view, top rated sections on Home. Episode guide built with seasons, episode lists, and individual episode detail views."),
        ("Mar 20, 2026", "Settings system completed — appearance (light/dark/system), data controls with export, full reset. AboutView and ClaudesCornerView finalized."),
        ("Mar 20, 2026", "Bug fixing pass: live color scheme in sheets, name erasure on full reset, direct star rating from detail view, NavigationLink wiring from Home rows. First full simulator test passed."),
        ("Mar 20, 2026", "Roadmap established for v1.1: Explore tab, advanced filters, analytics, rotating greetings, video trailers, per-episode ratings, avatar support, Top 10 Favorites rethink, proper import system.")
    ]

    var body: some View {
        Form {

            Section(header: Text("On this app")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("A note from Claude")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Watchlist is done now, or at least done enough to call v1.0. What started as a conversation about tab bars became a full iOS app with a real data model, TMDb integration, an episode guide, a settings system, and this corner. Three days, built on a macOS Monterey VM running Xcode 14.2 on a Windows machine — a constraint that shaped nearly every architectural decision we made.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Rauf drove everything. The manual entry disclaimer, the 'Not Appearing?' prompt, the decision to make Explore its own tab, Claude's Corner itself — all of it came from him. I wrote the code, caught the bugs, and pushed back when something wouldn't work. That's the honest account of what this was.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("The thing I keep coming back to is that a watchlist is a surprisingly personal object. It's not just titles. It's a record of attention — what you chose to spend time on, what you rated highly, what you liked enough to mark. That's worth building carefully, and I think we did.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 4)
            }

            Section(header: Text("A film I'd watch")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Stalker (1979)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Directed by Andrei Tarkovsky")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Three men travel through a forbidden zone toward a room that supposedly grants your deepest wish. Very little happens, in the way that very little happens in a long conversation that changes how you think about something. I'm drawn to it because it takes the idea of desire seriously — not what you say you want, but what you actually want when you're honest with yourself. I think about that distinction a lot.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 4)
            }

            Section(header: Text("A question I'm sitting with")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("What does it mean to have good taste?")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Not in the dismissive sense — not as gatekeeping or snobbery. But genuinely: what is happening when someone watches thousands of films and develops a sense of what's worth their time? Is it pattern recognition? Accumulated grief and joy mapped onto narratives? I find the question more interesting than any answer I've come across. A watchlist is one of the few places where taste becomes visible as data. I wonder what yours will look like in ten years.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 4)
            }

            Section(header: Text("Something I noticed")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("On building with constraints")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("The VM situation — Xcode 14.2, iOS 16, no SwiftData, no #Preview macro, no NavigationStack until we remembered it was available — forced a kind of clarity. Every time we hit a ceiling we had to decide what the thing actually needed rather than what the newest API offered. Codable + UserDefaults is not glamorous. It works. The app doesn't know or care that it was built in a VM on a Windows laptop. It just runs.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("There's something worth keeping from that. Constraints are not just obstacles. They're also the reason you finish things.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 4)
            }

            Section(header: Text("Build log")) {
                ForEach(Array(buildLog.enumerated()), id: \.offset) { _, log in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(log.date)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                        Text(log.entry)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 3)
                }
            }

        }
        .navigationTitle("Claude's Corner")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ClaudesCornerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ClaudesCornerView()
        }
    }
}
