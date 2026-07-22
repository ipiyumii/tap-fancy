//
//  UserProfile.swift
//  PlayHubApp
//
//  Created by Piyumi Imalka on 2026-07-22.
//

import Foundation

struct UserProfile: Codable {
    var name: String
    var username: String
    var bio: String
    var favoriteGame: String
    var avatarEmoji: String
    var joinDate: Date

    init(
        name: String = "",
        username: String = "",
        bio: String = "",
        favoriteGame: String = "Tap Frenzy",
        avatarEmoji: String = "😎",
        joinDate: Date = Date()
    ) {
        self.name = name
        self.username = username
        self.bio = bio
        self.favoriteGame = favoriteGame
        self.avatarEmoji = avatarEmoji
        self.joinDate = joinDate
    }

    var isComplete: Bool {
        !name.isEmpty && !username.isEmpty
    }
}

class ProfileManager {
    static let shared = ProfileManager()
    private let profileKey = "userProfile"

    private init() {}

    func saveProfile(_ profile: UserProfile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }

    func loadProfile() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: profileKey),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            return nil
        }
        return profile
    }

    func deleteProfile() {
        UserDefaults.standard.removeObject(forKey: profileKey)
    }

    var hasProfile: Bool {
        loadProfile() != nil
    }
}
