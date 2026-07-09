
import Foundation

class StatsVM: ObservableObject {
    @Published var sessions: [GameSession] = []
    
    init() {
        loadSessions()
    }
    
    func loadSessions() {
        sessions = SessionManager.shared.loadSessions()
    }
    
    var totalGames: Int {
        sessions.count
    }
    
    var totalScore: Int {
        sessions.reduce(0) { $0 + $1.score }
    }
    
    func bestScore(for mode: GameMode) -> Int {
        sessions
            .filter { $0.mode == mode }
            .map { $0.score }
            .max() ?? 0
    }
    
    func gamesPlayed(for mode: GameMode) -> Int {
        sessions.filter { $0.mode == mode }.count
    }
    
    // get last 10 games
    var recentGames: [GameSession] {
        Array(sessions.sorted { $0.timestamp > $1.timestamp }.prefix(10))
    }
    
    func clearAllStats() {
        SessionManager.shared.clearAllSessions()
        sessions = []
    }
}

