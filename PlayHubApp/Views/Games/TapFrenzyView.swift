
import Foundation
import SwiftUI

struct TapFrenzyView: View {
    @StateObject private var viewModel = TapFrenzyVM()
    @Environment(\.dismiss) var dismiss

    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var tapScale: CGFloat = 1.0
    @State private var showRipple = false

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 25) {
                // header with high score
                VStack(spacing: 8) {
                    Text("TAP FRENZY")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)

                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(AppTheme.accent)
                        Text("Best: \(viewModel.highScore)")
                            .foregroundColor(AppTheme.textSecondary)
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

            // toaster
            ToastBanner(
                message: toastMessage,
                icon: "flame.fill",
                color: AppTheme.accent,
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

    var gameView: some View {
        VStack(spacing: 35) {
            // timer badge
            ScoreBadge(label: "TIME", value: viewModel.timeRemaining, fontSize: 80)

            // score 
            ScoreBadge(label: "SCORE", value: viewModel.score, fontSize: 60)

            ZStack {
                // Ripple effect 
                if showRipple {
                    Circle()
                        .stroke(AppTheme.accent.opacity(0.5), lineWidth: 3)
                        .frame(width: 200, height: 200)
                        .scaleEffect(showRipple ? 1.5 : 1.0)
                        .opacity(showRipple ? 0 : 1)
                }

                Button(action: {
                    viewModel.handleTap()
                    animateTap()
                }) {
                    Text("TAP!")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(AppTheme.textOnColor)
                        .frame(width: 200, height: 200)
                        .background(
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [AppTheme.accent, AppTheme.accentDark]),
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 100
                                    )
                                )
                        )
                        .clipShape(Circle())
                        .shadow(color: AppTheme.accent.opacity(0.5), radius: 15, x: 0, y: 5)
                }
                .scaleEffect(tapScale)
            }

            // Speed indicator
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundColor(AppTheme.accent)
                Text(tapSpeedText)
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(AppTheme.surface)
            .cornerRadius(20)
            .shadow(color: AppTheme.cardShadowColor, radius: 5)
        }
    }

    var tapSpeedText: String {
        let tapsPerSecond = viewModel.timeRemaining > 0 ?
            Double(viewModel.score) / Double(10 - viewModel.timeRemaining + 1) : 0

        if tapsPerSecond > 5 {
            return "Lightning Fast!"
        } else if tapsPerSecond > 3 {
            return "Great Speed!"
        } else if tapsPerSecond > 1 {
            return "Keep Going!"
        } else {
            return "Tap Faster!"
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
                    accentColor: AppTheme.tapFrenzy,
                    onPlayAgain: { viewModel.startGame() }
                )
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.accent)

                    Text("Ready to Tap?")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                        .multilineTextAlignment(.center)

                    Text("Tap as many times as you can in 10 seconds!")
                        .font(.headline)
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                BouncingPlayButton(title: "START GAME", color: AppTheme.accent) {
                    viewModel.startGame()
                }
            }
        }
    }

    private func animateTap() {
        tapScale = 0.9
        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
            tapScale = 1.0
        }

        showRipple = true
        withAnimation(.easeOut(duration: 0.4)) {
            showRipple = false
        }
    }

    private func checkMilestone(_ score: Int) {
        if score == 20 {
            toastMessage = "20 Taps! Keep it up!"
            withAnimation {
                showToast = true
            }
        } else if score == 50 {
            toastMessage = "50 Taps! Amazing!"
            withAnimation {
                showToast = true
            }
        } else if score == 100 {
            toastMessage = "100 Taps! Incredible!"
            withAnimation {
                showToast = true
            }
        }
    }
}
