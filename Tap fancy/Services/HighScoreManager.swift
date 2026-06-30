//
//  HighScoreManager.swift
//  Tap fancy
//
//  Created by Piyumi Imalka on 2026-06-30.
//

import Foundation


class HighScoreManager {

    static func getScore(for key: String) -> Int {
        UserDefaults.standard.integer(forKey: key)
    }

    static func save(score: Int, for key: String) {
        UserDefaults.standard.set(score, forKey: key)
    }
}
