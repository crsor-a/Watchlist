//
//  UserProfile.swift
//  Watchlist
//
//  Created by Rauf Taj on 3/19/26.
//

import Foundation

class UserProfile: ObservableObject {
    @Published var name: String {
        didSet {
            UserDefaults.standard.set(name, forKey: "user_name")
        }
    }

    init() {
        self.name = UserDefaults.standard.string(forKey: "user_name") ?? ""
    }
}
