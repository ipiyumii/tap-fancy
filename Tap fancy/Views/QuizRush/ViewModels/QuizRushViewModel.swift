import Foundation
import SwiftUI

enum QuizViewState {
    case loading
    case loaded
    case failed(Error)
}

@MainActor
class QuizRushViewModel: ObservableObject {
    @Published var questions: [TriviaQuestion] = []
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var streak = 0
    @Published var viewState: QuizViewState = .loading
    @Published var isGameActive = false
    @Published var highScore = UserDefaults.standard.integer(forKey: "quizRushHighScore")
    @Published var showCorrectFeedback = false
    @Published var showWrongFeedback = false
    @Published var isProcessingAnswer = false
    
    private var lastFetchTime: Date?
    private let minimumFetchInterval: TimeInterval = 5.0
    
    var currentQuestion: TriviaQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex >= questions.count - 1
    }
    
    var progress: String {
        guard !questions.isEmpty else { return "0 of 0" }
        return "\(min(currentQuestionIndex + 1, questions.count)) of \(questions.count)"
    }
    
    func loadQuestions() async {
        // rate limiting
        if let lastFetch = lastFetchTime {
            let timeSinceLastFetch = Date().timeIntervalSince(lastFetch)
            if timeSinceLastFetch < minimumFetchInterval {
                let waitTime = minimumFetchInterval - timeSinceLastFetch
                try? await Task.sleep(nanoseconds: UInt64(waitTime * 1_000_000_000))
            }
        }
        
        viewState = .loading
        
        do {
            let fetchedQuestions = try await TriviaService.fetchQuestions()
            self.questions = fetchedQuestions
            self.viewState = .loaded
            self.lastFetchTime = Date()
        } catch {
            self.viewState = .failed(error)
        }
    }
    
    func startGame() {
        score = 0
        streak = 0
        currentQuestionIndex = 0
        isGameActive = true
        showCorrectFeedback = false
        showWrongFeedback = false
        isProcessingAnswer = false
    }
    
    func handleAnswer(_ answer: String) {
        // prevent multiple taps
        guard !isProcessingAnswer else { return }
        guard let question = currentQuestion else { return }
        
        isProcessingAnswer = true
        
        let isCorrect = answer == question.correctAnswer
        
        if isCorrect {
            streak += 1
            let bonusPoints = streak >= 3 ? 2 : 1
            score += bonusPoints
            showCorrectFeedback = true
        } else {
            streak = 0
            score = max(0, score - 1)
            showWrongFeedback = true
        }
        
        // delay
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 sec
            
            await MainActor.run {
                self.showCorrectFeedback = false
                self.showWrongFeedback = false
                self.isProcessingAnswer = false
                self.moveToNextQuestion()
            }
        }
    }
    
    private func moveToNextQuestion() {
        if isLastQuestion {
            endGame()
        } else {
            currentQuestionIndex += 1
        }
    }
    
    func endGame() {
        isGameActive = false
        
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "quizRushHighScore")
        }
    }
    
    func retry() {
        Task {
            await loadQuestions()
        }
    }
}
