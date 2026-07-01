import SwiftUI

struct QuizRushView: View {
    @StateObject private var viewModel = QuizRushViewModel()
    @Environment(\.dismiss) var dismiss
    
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
                    Text("QUIZ RUSH")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("High Score: \(viewModel.highScore)")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
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
    }
    
    var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(2)
                .tint(.white)
            
            Text("Loading Questions...")
                .font(.headline)
                .foregroundColor(.white)
        }
    }
    
    func errorView(_ error: Error) -> some View {
        VStack(spacing: 30) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            Text("Failed to Load Questions")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                viewModel.retry()
            }) {
                Text("RETRY")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(Color.orange)
                    .cornerRadius(15)
            }
        }
    }
    
    var gameView: some View {
        VStack(spacing: 25) {
            //progress
            HStack(spacing: 30) {
                VStack {
                    Text("QUESTION")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    Text(viewModel.progress)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                VStack {
                    Text("SCORE")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    Text("\(viewModel.score)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                VStack {
                    Text("STREAK")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    Text("\(viewModel.streak)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(viewModel.streak >= 3 ? .yellow : .white)
                }
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(15)
            .padding(.horizontal)
            
            // quesion crd
            if let question = viewModel.currentQuestion {
                ScrollView {
                    VStack(spacing: 20) {
                        // question
                        Text(decodeHTML(question.question))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(15)
                        
                        // answer
                        VStack(spacing: 15) {
                            ForEach(question.allAnswers, id: \.self) { answer in
                                answerButton(answer: answer, question: question)
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
    
    func answerButton(answer: String, question: TriviaQuestion) -> some View {
        Button(action: {
            viewModel.handleAnswer(answer)
        }) {
            Text(decodeHTML(answer))
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(Color.white.opacity(0.3))
                .cornerRadius(12)
        }
        .disabled(viewModel.isProcessingAnswer)
    }
    
    var gameOverView: some View {
        VStack(spacing: 30) {
            if viewModel.score > 0 {
                VStack(spacing: 10) {
                    Text("QUIZ COMPLETE!")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Final Score")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(viewModel.score)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.yellow)
                    
                    if viewModel.score == viewModel.highScore && viewModel.score > 0 {
                        Text("NEW HIGH SCORE!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                    }
                }
            } else {
                VStack(spacing: 15) {
                    Text("Ready to Play?")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Answer 10 trivia questions!\nCorrect streaks give bonus points!")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            
            Button(action: {
                viewModel.startGame()
            }) {
                Text(viewModel.score > 0 ? "PLAY AGAIN" : "START QUIZ")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(Color.blue)
                    .cornerRadius(15)
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
