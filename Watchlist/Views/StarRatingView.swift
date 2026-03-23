//
//  StarRatingView.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/19/26.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Int
    var maxRating: Int = 5
    var interactive: Bool = false
    var onRate: ((Int) -> Void)? = nil

    var body: some View {
        HStack(spacing: 3) {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: 11))
                    .foregroundStyle(star <= rating ? .blue : Color(.systemGray3))
                    .onTapGesture {
                        if interactive { onRate?(star) }
                    }
            }
        }
    }
}
