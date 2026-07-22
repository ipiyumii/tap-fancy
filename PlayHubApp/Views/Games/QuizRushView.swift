
import Foundation
import SwiftUI

struct QuizRushView: View {
    @StateObject private var viewModel = QuizRushVM()
    @Environment(\.dismiss) var dismiss

    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastColor: Color = .green
    @State private var selectedAnswer: String? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.green, Color.teal]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // header
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.title)
                            .foregroundColor(.yellow)

                        Text("QUIZ RUSH")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.white)
                    }

                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.yellow)
                        Text("Best: \(viewModel.highScore)")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .font(.headline)
                }
                .padding(.top, 20)

                Spacer()

                Group {
                    switch viewModel.viewState {
                    case .loading:
                        loadingView
                    case .loaded:
                        if viewModel.isGameActive {
                            gameView
                        } else {
                            gameOverView
                        }
                    case .failed(let error):
                        errorView(error)
                    }
                }

                Spacer()
            }

            // toaster
            ToastBanner(
                message: toastMessage,
                icon: viewModel.streak >= 3 ? "flame.fill" : "checkmark.circle.fill",
                color: toastColor,
                isShowing: $showToast
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(viewModel.isGameActive)
        .toolbar {
            if !viewModel.isGameActive {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Home")
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
        .task {
            await viewModel.loadQuestions()
        }
        .onChange(of: viewModel.streak) { oldValue, newValue in
            if newValue == 3 {
                toastMessage = "3 Streak! +5 Bonus!"
                toastColor = .orange
                withAnimation { showToast = true }
            } else if newValue == 5 {
                toastMessage = "5 Streak! On Fire!"
                toastColor = .red
                withAnimation { showToast = true }
            }
        }
    }

    var loadingView: some View {
        VStack(spacing: 25) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 4)
                    .frame(width: 80, height: 80)

                ProgressView()
                    .scaleEffect(2)
                    .tint(.white)
            }

            Text("Loading Questions...")
                .font(.headline)
                .foregroundColor(.white)

            Text("Preparing your quiz challenge!")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(20)
    }

    func errorView(_ error: Error) -> some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.2))
                    .frame(width: 100, height: 100)

                Image(systemName: "wifi.exclamationmark")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
            }

            VStack(spacing: 10) {
                Text("Oops! Something went wrong")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Check your internet connection")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }

            Button(action: {
                viewModel.retry()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(Color.orange)
                .cornerRadius(15)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
    }

    var gameView: some View {
        VStack(spacing: 20) {
            // score badge row
            HStack(spacing: 15) {
                VStack(spacing: 4) {
                    Text("Question")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text("\(viewModel.currentQuestionIndex + 1)/10")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

                Spacer()

                // Score
                VStack(spacing: 4) {
                    Text("Score")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text("\(viewModel.score)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                }

                Spacer()

                // streak 
                if viewModel.streak > 0 {
                    StreakBadge(streakCount: viewModel.streak)
                }
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(15)
            .padding(.horizontal)

            // progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.yellow)
                        .frame(width: geometry.size.width * CGFloat(viewModel.currentQuestionIndex + 1) / 10, height: 8)
                        .animation(.easeInOut, value: viewModel.currentQuestionIndex)
                }
            }
            .frame(height: 8)
            .padding(.horizontal)

            // question card
            if let question = viewModel.currentQuestion {
                ScrollView {
                    VStack(spacing: 20) {
                        // question
                        VStack(spacing: 10) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.yellow)

                            Text(decodeHTML(question.question))
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)

                        // answers
                        VStack(spacing: 12) {
                            ForEach(Array(question.allAnswers.enumerated()), id: \.element) { index, answer in
                                EnhancedAnswerButton(
                                    answer: decodeHTML(answer),
                                    index: index,
                                    isSelected: selectedAnswer == answer,
                                    isCorrect: answer == question.correctAnswer,
                                    showResult: viewModel.isProcessingAnswer && selectedAnswer != nil,
                                    action: {
                                        selectedAnswer = answer
                                        viewModel.handleAnswer(answer)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            selectedAnswer = nil
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            viewModel.showCorrectFeedback ? Color.green.opacity(0.3) :
                            viewModel.showWrongFeedback ? Color.red.opacity(0.3) :
                            Color.clear
                        )
                        .animation(.easeInOut(duration: 0.3), value: viewModel.showCorrectFeedback)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.showWrongFeedback)
                )
            }
        }
    }

    var gameOverView: some View {
        VStack(spacing: 30) {
            if viewModel.score > 0 {
                ResultView(
                    gameTitle: "Quiz Rush",
                    score: viewModel.score,
                    highScore: viewModel.highScore,
                    isNewHighScore: viewModel.score == viewModel.highScore,
                    shareMessage: "I just scored \(viewModel.score) on Quiz Rush - beat that! 🧠",
                    accentColor: .blue,
                    onPlayAgain: { viewModel.startGame() }
                )
            } else {
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 100, height: 100)

                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }

                    Text("Ready to Play?")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)

                    VStack(spacing: 8) {
                        Text("Answer 10 trivia questions!")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))

                        Text("Build streaks for bonus points!")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }

                    // scoring info
                    HStack(spacing: 20) {
                        ScoringInfo(points: "+10", label: "Correct")
                        ScoringInfo(points: "+5", label: "3+ Streak")
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                }

                BouncingPlayButton(title: "START QUIZ", color: .blue) {
                    viewModel.startGame()
                }
            }
        }
    }

    private func decodeHTML(_ html: String) -> String {
        guard let data = html.data(using: .utf8) else { return html }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return html
        }

        return attributedString.string
    }
}

struct EnhancedAnswerButton: View {
    let answer: String
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool
    let showResult: Bool
    let action: () -> Void

    private let letters = ["A", "B", "C", "D"]

    var backgroundColor: Color {
        if showResult && isSelected {
            return isCorrect ? Color.green.opacity(0.5) : Color.red.opacity(0.5)
        }
        return Color.white.opacity(0.3)
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Text(letters[index])
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 35, height: 35)
                    .background(Circle().fill(Color.white.opacity(0.3)))

                Text(answer)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)

                Spacer()

                if showResult && isSelected {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? .green : .red)
                        .font(.title2)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
            )
        }
        .disabled(showResult)
    }
}

struct ScoringInfo: View {
    let points: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(points)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.yellow)

            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

#Preview {
    NavigationStack {
        QuizRushView()
    }
}
