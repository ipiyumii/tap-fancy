
import Foundation
import SwiftUI
import CoreLocation

class TapFrenzyVM: ObservableObject {
    @Published var score = 0
    @Published var timeRemaining = 10
    @Published var isGameActive = false
    @Published var highScore: Int
    
    private var timer: Timer?
    
    init() {
        self.highScore = UserDefaults.standard.integer(forKey: "tapFrenzyHighScore")
    }
    
    func startGame() {
        score = 0
        timeRemaining = 10
        isGameActive = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.tick()
            }
        }
    }
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            endGame()
        }
    }
    
    func handleTap() {
        score += 1
    }
    
    func endGame() {
        timer?.invalidate()
        timer = nil
        isGameActive = false
        
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "tapFrenzyHighScore")
        }
        
        // save session
        let location = LocationService.shared.currentLocation
        let session = GameSession(
            mode: .tapFrenzy,
            score: score,
            latitude: location?.coordinate.latitude,
            longitude: location?.coordinate.longitude
        )
        SessionManager.shared.saveSession(session)
    }
}

