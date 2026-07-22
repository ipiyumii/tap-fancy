
import Foundation
import SwiftUI
import Charts

struct StatsTab: View {
    @StateObject private var viewModel = StatsVM()
    @State private var selectedStatType = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HeroStatsCard(totalGames: viewModel.totalGames, totalScore: viewModel.totalScore)
                PersonalBestsCard(viewModel: viewModel)
                ChartCard(sessions: viewModel.sessions)
                RecentGamesCard(recentGames: viewModel.recentGames)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Stats")
        .onAppear {
            viewModel.loadSessions()
        }
    }
}

struct HeroStatsCard: View {
    let totalGames: Int
    let totalScore: Int

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.white)
                Text("Your Progress")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }

            HStack(spacing: 40) {
                StatCircle(value: "\(totalGames)", label: "Games\nPlayed", color: .blue)
                StatCircle(value: "\(totalScore)", label: "Total\nScore", color: .green)
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

struct StatCircle: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 80, height: 80)

                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
}

struct PersonalBestsCard: View {
    @ObservedObject var viewModel: StatsVM

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundColor(.yellow)
                Text("Personal Bests")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }

            VStack(spacing: 12) {
                ForEach(GameMode.allCases, id: \.self) { mode in
                    PersonalBestRow(mode: mode, score: viewModel.bestScore(for: mode))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct PersonalBestRow: View {
    let mode: GameMode
    let score: Int

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(modeColor.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: mode.icon)
                    .foregroundColor(modeColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(mode.rawValue)
                    .font(.headline)
                Text(score > 0 ? "Best: \(score)" : "Not played yet")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            if score > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text("\(score)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(modeColor)
                }
            } else {
                Text("--")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
    }

    var modeColor: Color {
        switch mode {
        case .tapFrenzy: return .orange
        case .lightItUp: return .yellow
        case .quizRush: return .green
        }
    }
}

struct ChartCard: View {
    let sessions: [GameSession]

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.blue)
                Text("Score History")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }

            if sessions.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "gamecontroller")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No games played yet")
                        .foregroundColor(.gray)
                    Text("Play some games to see your stats!")
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.7))
                }
                .padding(.vertical, 30)
            } else {
                Chart(sessions) { session in
                    BarMark(
                        x: .value("Game", session.timestamp, unit: .minute),
                        y: .value("Score", session.score)
                    )
                    .foregroundStyle(by: .value("Mode", session.mode.rawValue))
                    .cornerRadius(4)
                }
                .chartForegroundStyleScale([
                    "Tap Frenzy": Color.orange,
                    "Light It Up": Color.yellow,
                    "Quiz Rush": Color.green
                ])
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct RecentGamesCard: View {
    let recentGames: [GameSession]

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.purple)
                Text("Recent Games")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()

                if !recentGames.isEmpty {
                    Text("\(recentGames.count) games")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            if recentGames.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "clock")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No recent games")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 20)
            } else {
                VStack(spacing: 0) {
                    ForEach(recentGames) { session in
                        RecentGameRow(session: session)

                        if session.id != recentGames.last?.id {
                            Divider()
                                .padding(.leading, 55)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct RecentGameRow: View {
    let session: GameSession

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(modeColor.opacity(0.2))
                    .frame(width: 45, height: 45)

                Image(systemName: session.mode.icon)
                    .foregroundColor(modeColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(session.mode.rawValue)
                    .font(.headline)

                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text(session.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(session.score)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(modeColor)

                Text("points")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 10)
    }

    var modeColor: Color {
        switch session.mode {
        case .tapFrenzy: return .orange
        case .lightItUp: return .yellow
        case .quizRush: return .green
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 100)
    }
}
