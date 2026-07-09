import Foundation
import SwiftUI
import CoreLocation

struct LightCard: Identifiable {
    let id = UUID()
    var isLit: Bool = false
}

@MainActor
class LightItUpVM: ObservableObject {
    
    @Published var cards: [LightCard] = []
    @Published var score = 0
    @Published var timeRemaining = 60
    @Published var isGameActive = false
    @Published var highScore: Int
    @Published var gridColumns = 3
    
    private var timer: Timer?
    private var lightTimer: Timer?
    
    init() {
        self.highScore = UserDefaults.standard.integer(forKey: "lightItUpHighScore")
    }
    
    func startGame() {
        score = 0
        timeRemaining = 60
        isGameActive = true
        gridColumns = 3
        
        cards = (0..<9).map { _ in LightCard() }
        
        timer?.invalidate()
        lightTimer?.invalidate()
        
        //countdown 
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor [weak self] in
                self?.tick()
            }
        }
        
        // random light
        lightRandomCard()
        
        lightTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            Task { @MainActor [weak self] in
                self?.lightRandomCard()
            }
        }
    }
        
    private func tick() {
        guard isGameActive else { return }
        
        if timeRemaining > 0 {
            timeRemaining -= 1
            
            // difficulty increase
            if timeRemaining == 45 {
                gridColumns = 4
                cards = (0..<16).map { _ in LightCard() }
                
            } else if timeRemaining == 30 {
                gridColumns = 5
                cards = (0..<25).map { _ in LightCard() }
            }
            
        } else {
            endGame()
        }
    }
        
    func lightRandomCard() {
        guard isGameActive else { return }
        
        for index in cards.indices {
            cards[index].isLit = false
        }
        
        if let randomIndex = cards.indices.randomElement() {
            withAnimation {
                cards[randomIndex].isLit = true
            }
        }
    }
        
    func handleCardTap(_ card: LightCard) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else {
            return
        }
        
        if cards[index].isLit {
            withAnimation {
                score += 1
                cards[index].isLit = false
            }
        } else {
            withAnimation {
                score = max(0, score - 1)
            }
        }
    }
    
    func endGame() {
        timer?.invalidate()
        timer = nil
        
        lightTimer?.invalidate()
        lightTimer = nil
        
        isGameActive = false
        
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(
                highScore,
                forKey: "lightItUpHighScore"
            )
        }
        
        let location = LocationService.shared.currentLocation
        
        let session = GameSession(
            mode: .lightItUp,
            score: score,
            latitude: location?.coordinate.latitude,
            longitude: location?.coordinate.longitude
        )
        
        SessionManager.shared.saveSession(session)
    }
}
