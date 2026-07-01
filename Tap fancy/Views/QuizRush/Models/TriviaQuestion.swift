import Foundation

struct TriviaQuestion: Codable, Identifiable {
    let id = UUID()
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
    
    // cache shuffled answers
    private var cachedAnswers: [String]?
    
    var allAnswers: [String] {
        if let cached = cachedAnswers {
            return cached
        }
        let shuffled = (incorrectAnswers + [correctAnswer]).shuffled()
        return shuffled
    }
}
