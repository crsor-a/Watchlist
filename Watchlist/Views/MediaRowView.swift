//
//  MediaRowView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/19/26.
//

import SwiftUI

struct MediaRowView: View {
    let item: MediaItem
    var rank: Int? = nil

    var body: some View {
        HStack(spacing: 10) {
            if let rank {
                Text("\(rank)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 20, alignment: .center)
            }

            AsyncImage(url: item.posterURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(.systemGray4))
            }
            .frame(width: 40, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 5))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)

                Text([item.year.map { String($0) }, item.genre]
                    .compactMap { $0 }
                    .joined(separator: " · "))
                    .font(.caption)
                    .foregroundColor(.secondary)

                StarRatingView(rating: item.rating)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
    }
}

struct MediaRowView_Previews: PreviewProvider {
    static var previews: some View {
        MediaRowView(item: MediaItem(
            title: "Dune: Part Two",
            type: .movie,
            year: 2024,
            genre: "Sci-Fi",
            rating: 5,
            isWatched: true
        ))
    }
}
