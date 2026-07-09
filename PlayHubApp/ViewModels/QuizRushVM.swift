import Foundation
import SwiftUI
import CoreLocation

enum QuizViewState {
    case loading
    case loaded
    case failed(Error)
}

class QuizRushVM: ObservableObject {
    @Published var questions: [TriviaQuestion] = []
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var streak = 0
    @Published var viewState: QuizViewState = .loading
    @Published var isGameActive = false
    @Published var highScore: Int
    @Published var showCorrectFeedback = false
    @Published var showWrongFeedback = false
    @Published var isProcessingAnswer = false
    
    private var lastFetchTime: Date?
    
    init() {
        self.highScore = UserDefaults.standard.integer(forKey: "quizRushHighScore")
    }
    
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
        // wait a bit before fetching again
        if let lastFetch = lastFetchTime {
            let timeSinceLastFetch = Date().timeIntervalSince(lastFetch)
            if timeSinceLastFetch < 5.0 {
                try? await Task.sleep(nanoseconds: UInt64((5.0 - timeSinceLastFetch) * 1_000_000_000))
            }
        }
        
        await MainActor.run {
            viewState = .loading
        }
        
        do {
            let fetchedQuestions = try await TriviaAPI.fetchQuestions()
            await MainActor.run {
                self.questions = fetchedQuestions
                self.viewState = .loaded
                self.lastFetchTime = Date()
            }
        } catch {
            print("error loading questions: \(error)")
            await MainActor.run {
                self.viewState = .failed(error)
            }
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
        
        // wait 1sec; move on
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
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
        
        // save the session
        let location = LocationService.shared.currentLocation
        let session = GameSession(
            mode: .quizRush,
            score: score,
            latitude: location?.coordinate.latitude,
            longitude: location?.coordinate.longitude
        )
        SessionManager.shared.saveSession(session)
    }
    
    func retry() {
        Task {
            await loadQuestions()
        }
    }
}

