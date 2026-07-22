
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
            AppTheme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // header with high score
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .font(.title)
                            .foregroundColor(AppTheme.accentLight)

                        Text("LIGHT IT UP")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                    }

                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(AppTheme.accent)
                        Text("Best: \(viewModel.highScore)")
                            .foregroundColor(AppTheme.textSecondary)
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
                color: AppTheme.success,
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
                        .foregroundColor(AppTheme.textPrimary)
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
                        .foregroundColor(AppTheme.textPrimary)
                    Text("SCORE")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            .padding()
            .background(AppTheme.surfaceLight)
            .cornerRadius(15)

            // difficulty indicator
            HStack {
                Image(systemName: "speedometer")
                    .foregroundColor(AppTheme.accent)
                Text(difficultyText)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textPrimary)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 6)
            .background(AppTheme.surface)
            .cornerRadius(10)
            .shadow(color: AppTheme.cardShadowColor, radius: 5)

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
                    accentColor: AppTheme.lightItUp,
                    onPlayAgain: { viewModel.startGame() }
                )
            } else {
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.accentLight.opacity(0.3))
                            .frame(width: 100, height: 100)

                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 50))
                            .foregroundColor(AppTheme.accentLight)
                    }

                    Text("Ready to Play?")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)

                    Text("Tap the glowing card before it goes dark!")
                        .font(.headline)
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // how to play hints
                    VStack(spacing: 8) {
                        HintRow(icon: "hand.tap", text: "Tap the lit card quickly")
                        HintRow(icon: "clock", text: "Speed increases over time")
                        HintRow(icon: "xmark.circle", text: "Miss = Game Over!")
                    }
                    .padding()
                    .background(AppTheme.surfaceLight)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                BouncingPlayButton(title: "START GAME", color: AppTheme.accent) {
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
                    .fill(AppTheme.accentLight)
                    .frame(height: 120)
                    .blur(radius: 15)
                    .opacity(glowOpacity)
            }

            RoundedRectangle(cornerRadius: 15)
                .fill(
                    isLit ?
                    LinearGradient(
                        gradient: Gradient(colors: [AppTheme.accentLight, AppTheme.accent]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        gradient: Gradient(colors: [AppTheme.surface, AppTheme.surface]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isLit ? AppTheme.textOnColor.opacity(0.5) : AppTheme.textMuted.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: isLit ? AppTheme.accentLight.opacity(0.6) : Color.clear, radius: 10)
                .scaleEffect(isLit ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLit)

            if isLit {
                Image(systemName: "sparkle")
                    .font(.title)
                    .foregroundColor(AppTheme.textOnColor)
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
                .foregroundColor(AppTheme.accent)
                .frame(width: 25)

            Text(text)
                .font(.subheadline)
                .foregroundColor(AppTheme.textPrimary)

            Spacer()
        }
    }
}

struct CardView: View {
    let isLit: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(isLit ? AppTheme.accentLight : AppTheme.surface)
            .frame(height: 120)
            .shadow(color: isLit ? AppTheme.accentLight.opacity(0.6) : Color.clear, radius: 10)
            .scaleEffect(isLit ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLit)
    }
}
