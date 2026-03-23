//
//  SeasonListView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/20/26.
//

import SwiftUI

struct SeasonListView: View {
    let tvID: Int
    let detail: TMDbTVDetail

    var body: some View {
        List {
            ForEach(1...(detail.numberOfSeasons ?? 1), id: \.self) { season in
                NavigationLink(destination: EpisodeListView(tvID: tvID, seasonNumber: season)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Season \(season)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Seasons")
        .navigationBarTitleDisplayMode(.inline)
    }
}
