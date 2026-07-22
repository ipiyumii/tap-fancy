
import Foundation
import SwiftUI

struct LightItUpView: View {
    @StateObject private var viewModel = LightItUpVM()
    @Environment(\.dismiss) var dismiss

    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastIcon = "star.fill"

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // header with high score
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .font(.title)
                            .foregroundColor(.yellow)

                        Text("LIGHT IT UP")
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

                if viewModel.isGameActive {
                    activeGameView
                } else {
                    gameOverView
                }

                Spacer()
            }

            // toaster
            ToastBanner(
                message: toastMessage,
                icon: toastIcon,
                color: .green,
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
        .onChange(of: viewModel.score) { oldValue, newValue in
            checkMilestone(newValue)
        }
    }

    var activeGameView: some View {
        VStack(spacing: 20) {
            // score badges row
            HStack(spacing: 30) {
                ScoreBadge(label: "TIME", value: viewModel.timeRemaining)

                VStack {
                    Text("\(viewModel.score)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    Text("SCORE")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
            .background(Color.white.opacity(0.15))
            .cornerRadius(15)

            // difficulty indicator
            HStack {
                Image(systemName: "speedometer")
                    .foregroundColor(.yellow)
                Text(difficultyText)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.2))
            .cornerRadius(10)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: viewModel.gridColumns), spacing: 15) {
                ForEach(viewModel.cards) { card in
                    EnhancedCardView(isLit: card.isLit)
                        .onTapGesture {
                            viewModel.handleCardTap(card)
                        }
                }
            }
            .padding()
        }
    }

    var difficultyText: String {
        if viewModel.score >= 20 {
            return "Expert Mode!"
        } else if viewModel.score >= 10 {
            return "Getting Harder!"
        } else {
            return "Warm Up"
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
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.yellow.opacity(0.3))
                            .frame(width: 100, height: 100)

                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow)
                    }

                    Text("Ready to Play?")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)

                    Text("Tap the glowing card before it goes dark!")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // how to play hints
                    VStack(spacing: 8) {
                        HintRow(icon: "hand.tap", text: "Tap the lit card quickly")
                        HintRow(icon: "clock", text: "Speed increases over time")
                        HintRow(icon: "xmark.circle", text: "Miss = Game Over!")
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                BouncingPlayButton(title: "START GAME", color: .green) {
                    viewModel.startGame()
                }
            }
        }
    }

    private func checkMilestone(_ score: Int) {
        if score == 5 {
            toastMessage = "Nice start!"
            toastIcon = "hand.thumbsup.fill"
            withAnimation { showToast = true }
        } else if score == 15 {
            toastMessage = "You're on fire!"
            toastIcon = "flame.fill"
            withAnimation { showToast = true }
        } else if score == 30 {
            toastMessage = "Unstoppable!"
            toastIcon = "star.fill"
            withAnimation { showToast = true }
        }
    }
}

struct EnhancedCardView: View {
    let isLit: Bool

    @State private var glowOpacity: Double = 0.5

    var body: some View {
        ZStack {
            if isLit {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.yellow)
                    .frame(height: 120)
                    .blur(radius: 15)
                    .opacity(glowOpacity)
            }

            RoundedRectangle(cornerRadius: 15)
                .fill(
                    isLit ?
                    LinearGradient(
                        gradient: Gradient(colors: [Color.yellow, Color.orange]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.2)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isLit ? Color.white.opacity(0.5) : Color.clear, lineWidth: 2)
                )
                .shadow(color: isLit ? Color.yellow.opacity(0.6) : Color.clear, radius: 10)
                .scaleEffect(isLit ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLit)

            if isLit {
                Image(systemName: "sparkle")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            if isLit {
                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    glowOpacity = 1.0
                }
            }
        }
    }
}

struct HintRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.yellow)
                .frame(width: 25)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))

            Spacer()
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
