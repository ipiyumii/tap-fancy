
import Foundation

struct GameSession: Codable, Identifiable {
    let id: UUID
    let mode: GameMode
    let score: Int
    let timestamp: Date
    let latitude: Double?
    let longitude: Double?
    
    init(mode: GameMode, score: Int, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = UUID()
        self.mode = mode
        self.score = score
        self.timestamp = Date()
        self.latitude = latitude
        self.longitude = longitude
    }
}

// manage saving games session
class SessionManager {
    static let shared = SessionManager()
    
    func loadSessions() -> [GameSession] {
        guard let data = UserDefaults.standard.data(forKey: "gameSessions") else {
            return []
        }
        
        do {
            let sessions = try JSONDecoder().decode([GameSession].self, from: data)
            return sessions
        } catch {
            print("error loading sessions")
            return []
        }
    }
    
    func saveSession(_ session: GameSession) {
        var sessions = loadSessions()
        sessions.append(session)
        
        do {
            let data = try JSONEncoder().encode(sessions)
            UserDefaults.standard.set(data, forKey: "gameSessions")
        } catch {
            print("error saving session")
        }
    }
    
    func clearAllSessions() {
        UserDefaults.standard.removeObject(forKey: "gameSessions")
    }
}
