
import Foundation
import SwiftUI

struct LightItUpView: View {
    @StateObject private var viewModel = LightItUpVM()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // header with high score
                VStack(spacing: 10) {
                    Text("LIGHT IT UP")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.yellow)
                        Text("Best: \(viewModel.highScore)")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .font(.headline)
                }
                .padding(.top, 20)
                
                if viewModel.isGameActive {
                    activeGameView
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
    
    var activeGameView: some View {
        VStack(spacing: 20) {
            // score badges row
            HStack(spacing: 50) {
                ScoreBadge(label: "TIME", value: viewModel.timeRemaining)
                ScoreBadge(label: "SCORE", value: viewModel.score)
            }
            .padding()
            .background(Color.white.opacity(0.15))
            .cornerRadius(15)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: viewModel.gridColumns), spacing: 15) {
                ForEach(viewModel.cards) { card in
                    CardView(isLit: card.isLit)
                        .onTapGesture {
                            viewModel.handleCardTap(card)
                        }
                }
            }
            .padding()
        }
    }
    
    var gameOverView: some View {
        VStack(spacing: 30) {
            if viewModel.score > 0 {
                ResultView(
                    gameTitle: "Light It Up",
                    score: viewModel.score,
                    highScore: viewModel.highScore,
                    isNewHighScore: viewModel.score == viewModel.highScore,
                    shareMessage: "I just scored \(viewModel.score) on Light It Up - beat that! 💡",
                    accentColor: .green,
                    onPlayAgain: { viewModel.startGame() }
                )
            } else {
                VStack(spacing: 15) {
                    Text("Ready to Play?")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Tap the glowing card before it goes dark!")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
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

struct CardView: View {
    let isLit: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(isLit ? Color.yellow : Color.white.opacity(0.3))
            .frame(height: 120)
            .shadow(color: isLit ? Color.yellow.opacity(0.6) : Color.clear, radius: 10)
            .scaleEffect(isLit ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLit)
    }
}
