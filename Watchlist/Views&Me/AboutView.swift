//
//  AboutView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/20/26.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {

                Section(header: Text("Credits")) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Watchlist")
                            .font(.headline)
                        Text("Designed and developed by Rauf Taj.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Built with Claude")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Architecture, design direction, and code authored in collaboration with Claude (Anthropic). Claude served as development partner across data modeling, UI design, API planning, and SwiftUI implementation.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 4)
                }

                Section(
                    header: Text("Powered by TMDb"),
                    footer: Text("This app uses the TMDb API but is not endorsed or certified by TMDb.")
                ) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("The Movie Database (TMDb)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("TMDb powers Watchlist's search and auto-fill functionality, providing title metadata including release year, genre, runtime, cast, director, synopsis, community ratings, and poster imagery.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 4)
                }

                Section(header: Text("App info")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Data storage")
                        Spacer()
                        Text("On device")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("March 2026")
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    NavigationLink(destination: ClaudesCornerView()) {
                        HStack(spacing: 10) {
                            Image(systemName: "sparkles")
                                .foregroundColor(.blue)
                            Text("Claude's Corner")
                                .fontWeight(.medium)
                        }
                    }
                }

            }
            .navigationTitle("About Watchlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
