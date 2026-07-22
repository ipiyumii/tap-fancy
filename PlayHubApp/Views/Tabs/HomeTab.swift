
import Foundation
import SwiftUI
struct HomeTab: View {
    @State private var showTapFrenzySheet = false
    @State private var showLightItUpSheet = false
    @State private var showQuizRushSheet = false
    @State private var showCountdown = false
    @State private var selectedGame: GameMode? = nil
    @State private var activeGame: GameMode? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // App Title with fun animation
                    VStack(spacing: 8) {
                        HStack(spacing: 10) {
                            Image(systemName: "gamecontroller.fill")
                                .font(.system(size: 35))
                                .foregroundColor(.yellow)

                            Text("PlayHub")
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(.white)
                        }

                        Text("Choose your adventure!")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 30)

                    // Welcome Banner with rotating tips
                    WelcomeBanner()
                        .padding(.top, 5)

                    // Daily Challenge Banner
                    DailyChallengeBanner()
                        .padding(.top, 5)

                    // Games Section
                    VStack(spacing: 15) {
                        Text("Games")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        // Tap Frenzy Card
                        Button(action: {
                            showTapFrenzySheet = true
                        }) {
                            AnimatedGameCard(
                                title: "Tap Frenzy",
                                icon: "hand.tap.fill",
                                color: .orange,
                                description: "Tap as fast as you can!"
                            )
                        }
                        .padding(.horizontal)

                        // Light It Up Card
                        Button(action: {
                            showLightItUpSheet = true
                        }) {
                            AnimatedGameCard(
                                title: "Light It Up",
                                icon: "lightbulb.fill",
                                color: .yellow,
                                description: "Find the glowing card!"
                            )
                        }
                        .padding(.horizontal)

                        // Quiz Rush Card
                        Button(action: {
                            showQuizRushSheet = true
                        }) {
                            AnimatedGameCard(
                                title: "Quiz Rush",
                                icon: "questionmark.circle.fill",
                                color: .green,
                                description: "Test your knowledge!"
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 10)

                    Spacer(minLength: 30)
                }
            }

            // Countdown Overlay
            CountdownOverlay(isShowing: $showCountdown) {
                activeGame = selectedGame
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
        .sheet(isPresented: $showTapFrenzySheet) {
            GameStartSheet(
                gameName: "Tap Frenzy",
                gameIcon: "hand.tap.fill",
                gameColor: .orange,
                bestScore: UserDefaults.standard.integer(forKey: "tapFrenzyHighScore")
            ) {
                selectedGame = .tapFrenzy
                showCountdown = true
            }
        }
        .sheet(isPresented: $showLightItUpSheet) {
            GameStartSheet(
                gameName: "Light It Up",
                gameIcon: "lightbulb.fill",
                gameColor: .yellow,
                bestScore: UserDefaults.standard.integer(forKey: "lightItUpHighScore")
            ) {
                selectedGame = .lightItUp
                showCountdown = true
            }
        }
        .sheet(isPresented: $showQuizRushSheet) {
            GameStartSheet(
                gameName: "Quiz Rush",
                gameIcon: "questionmark.circle.fill",
                gameColor: .green,
                bestScore: UserDefaults.standard.integer(forKey: "quizRushHighScore")
            ) {
                selectedGame = .quizRush
                showCountdown = true
            }
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
                .foregroundColor(.white)

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white)
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
