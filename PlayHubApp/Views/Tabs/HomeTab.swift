
import Foundation
import SwiftUI
struct HomeTab: View {
    @State private var showGamePreview = false
    @State private var selectedGame: GameMode? = nil
    @State private var activeGame: GameMode? = nil

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // App Title with fun animation
                    VStack(spacing: 8) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.primaryGradient)
                                    .frame(width: 48, height: 48)

                                Image(systemName: "gamecontroller.fill")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }

                            Text("PlayHub")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                        }

                        Text("Choose your adventure!")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.top, 20)

                    // Welcome Banner with rotating tips
                    WelcomeBanner()
                        .padding(.top, 5)

                    // Daily Challenge Banner
                    DailyChallengeBanner()
                        .padding(.top, 5)

                    // Games Section
                    VStack(spacing: 12) {
                        Text("Games")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)

                        // Tap Frenzy Card
                        Button(action: {
                            selectedGame = .tapFrenzy
                            showGamePreview = true
                        }) {
                            AnimatedGameCard(
                                title: "Tap Frenzy",
                                icon: "hand.tap.fill",
                                color: AppTheme.tapFrenzy,
                                description: "Tap as fast as you can!"
                            )
                        }

                        // Light It Up Card
                        Button(action: {
                            selectedGame = .lightItUp
                            showGamePreview = true
                        }) {
                            AnimatedGameCard(
                                title: "Light It Up",
                                icon: "lightbulb.fill",
                                color: AppTheme.lightItUp,
                                description: "Find the glowing card!"
                            )
                        }

                        // Quiz Rush Card
                        Button(action: {
                            selectedGame = .quizRush
                            showGamePreview = true
                        }) {
                            AnimatedGameCard(
                                title: "Quiz Rush",
                                icon: "questionmark.circle.fill",
                                color: AppTheme.quizRush,
                                description: "Test your knowledge!"
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    Spacer(minLength: 30)
                }
            }

            // Countdown Overlay
            if let game = selectedGame {
                QuickGamePreview(
                    gameName: game.rawValue,
                    gameIcon: game.icon,
                    gameColor: gameColor(for: game),
                    isShowing: $showGamePreview
                ) {
                    activeGame = game
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(item: $activeGame) { game in
            switch game {
            case .tapFrenzy:
                TapFrenzyView()
            case .lightItUp:
                LightItUpView()
            case .quizRush:
                QuizRushView()
            }
        }
    }

    private func gameColor(for mode: GameMode) -> Color {
        switch mode {
        case .tapFrenzy: return AppTheme.tapFrenzy
        case .lightItUp: return AppTheme.lightItUp
        case .quizRush: return AppTheme.quizRush
        }
    }
}

// Keep the simple GameButton for backwards compatibility
struct GameButton: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(AppTheme.textOnColor)

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.textOnColor)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(AppTheme.textOnColor)
        }
        .padding()
        .background(color)
        .cornerRadius(15)
        .shadow(color: color.opacity(0.4), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    NavigationStack {
        HomeTab()
    }
}
