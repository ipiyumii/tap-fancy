import Foundation

enum GameMode: String, Codable, CaseIterable {
    case tapFrenzy = "Tap Frenzy"
    case lightItUp = "Light It Up"
    case quizRush = "Quiz Rush"
    
    var icon: String {
        switch self {
        case .tapFrenzy:
            return "hand.tap.fill"
        case .lightItUp:
            return "lightbulb.fill"
        case .quizRush:
            return "questionmark.circle.fill"
        }
    }
}
