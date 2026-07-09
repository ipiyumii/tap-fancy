
import Foundation
import SwiftUI

struct TapFrenzyView: View {
    @StateObject private var viewModel = TapFrenzyVM()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // header with high score
                VStack(spacing: 8) {
                    Text("TAP FRENZY")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.yellow)
                        Text("Best: \(viewModel.highScore)")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .font(.headline)
                }
                .padding(.top, 50)
                Spacer()
                
                if viewModel.isGameActive {
                    gameView
                } else {
                    gameOverView
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
    }
    
    var gameView: some View {
        VStack(spacing: 35) {
            // timer badge
            ScoreBadge(label: "TIME", value: viewModel.timeRemaining, fontSize: 80)
            
            // score 
            ScoreBadge(label: "SCORE", value: viewModel.score, fontSize: 60)
            
            Button(action: {
                viewModel.handleTap()
            }) {
                Text("TAP!")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 200)
                    .background(Color.orange)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            }
        }
    }
    
    var gameOverView: some View {
        VStack(spacing: 25) {
            if viewModel.score > 0 {
                ResultView(
                    gameTitle: "Tap Frenzy",
                    score: viewModel.score,
                    highScore: viewModel.highScore,
                    isNewHighScore: viewModel.score == viewModel.highScore,
                    shareMessage: "I just scored \(viewModel.score) on Tap Frenzy - beat that! 🎮",
                    accentColor: .green,
                    onPlayAgain: { viewModel.startGame() }
                )
            } else {
                Text("Ready to Play?")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    viewModel.startGame()
                }) {
                    Text("START GAME")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.green)
                        .cornerRadius(15)
                }
            }
        }
    }
}
