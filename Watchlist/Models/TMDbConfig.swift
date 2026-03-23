//
//  TMDbConfig.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/20/26.
//

import Foundation

enum TMDbConfig {
    static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["TMDbAPIKey"] as? String else {
            fatalError("TMDb API key not found in Config.plist")
        }
        return key
    }

    static var readToken: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let token = dict["TMDbReadToken"] as? String else {
            fatalError("TMDb read token not found in Config.plist")
        }
        return token
    }

    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
}
