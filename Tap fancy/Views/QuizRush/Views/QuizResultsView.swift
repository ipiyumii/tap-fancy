import SwiftUI

struct QuizResultsView: View {
    let score: Int
    let totalQuestions: Int
    let onPlayAgain: () -> Void
    let onExit: () -> Void
    
    var percentage: Double {
        return (Double(score) / Double(totalQuestions)) * 100
    }
    
    var resultMessage: String {
        switch percentage {
        case 90...100:
            return "Outstanding! 🎉"
        case 70..<90:
            return "Great Job!"
        case 50..<70:
            return "Good Effort!"
        default:
            return "Keep Practicing!"
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Quiz Complete!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(resultMessage)
                .font(.title2)
                .foregroundColor(.blue)
            
            // Score 
            VStack(spacing: 10) {
                Text("\(score)")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.green)
                
                Text("out of \(totalQuestions)")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                Text("\(Int(percentage))%")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
            
            // Buttons
            VStack(spacing: 15) {
                Button(action: onPlayAgain) {
                    Text("Play Again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: onExit) {
                    Text("Exit")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    QuizResultsView(score: 8, totalQuestions: 10, onPlayAgain: {}, onExit: {})
}
