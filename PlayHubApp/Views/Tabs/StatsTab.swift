
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
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(AppTheme.background)
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
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.white)
                Text("Your Progress")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }

            HStack(spacing: 30) {
                StatCircle(value: "\(totalGames)", label: "Games\nPlayed", color: AppTheme.accent)
                StatCircle(value: "\(totalScore)", label: "Total\nScore", color: AppTheme.teal)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: AppTheme.primary.opacity(0.25), radius: 12, x: 0, y: 6)
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
                    .frame(width: 72, height: 72)

                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            Text(label)
                .font(.caption)
                .foregroundColor(Color.white.opacity(0.85))
                .multilineTextAlignment(.center)
        }
    }
}

struct PersonalBestsCard: View {
    @ObservedObject var viewModel: StatsVM

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundColor(AppTheme.accent)
                Text("Personal Bests")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }

            VStack(spacing: 0) {
                ForEach(Array(GameMode.allCases.enumerated()), id: \.element) { index, mode in
                    PersonalBestRow(mode: mode, score: viewModel.bestScore(for: mode))

                    if index < GameMode.allCases.count - 1 {
                        Divider()
                            .background(AppTheme.textMuted.opacity(0.3))
                            .padding(.leading, 56)
                    }
                }
            }
        }
        .padding(20)
        .background(AppTheme.surfaceLight)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.primary.opacity(0.15), lineWidth: 1)
        )
    }
}

struct PersonalBestRow: View {
    let mode: GameMode
    let score: Int

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(modeColor.opacity(0.12))
                    .frame(width: 42, height: 42)

                Image(systemName: mode.icon)
                    .foregroundColor(modeColor)
                    .font(.body)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(mode.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.textPrimary)
                Text(score > 0 ? "Best: \(score)" : "Not played yet")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }

            Spacer()

            if score > 0 {
                Text("\(score)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(modeColor)
            } else {
                Text("--")
                    .font(.title3)
                    .foregroundColor(AppTheme.textMuted)
            }
        }
        .padding(.vertical, 10)
    }

    var modeColor: Color {
        switch mode {
        case .tapFrenzy: return AppTheme.tapFrenzy
        case .lightItUp: return AppTheme.lightItUp
        case .quizRush: return AppTheme.quizRush
        }
    }
}

struct ChartCard: View {
    let sessions: [GameSession]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(AppTheme.primary)
                Text("Score History")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }

            if sessions.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "gamecontroller")
                        .font(.system(size: 36))
                        .foregroundColor(AppTheme.textMuted)
                    Text("No games played yet")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textSecondary)
                    Text("Play some games to see your stats!")
                        .font(.caption)
                        .foregroundColor(AppTheme.textMuted)
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
                    "Tap Frenzy": AppTheme.tapFrenzy,
                    "Light It Up": AppTheme.lightItUp,
                    "Quiz Rush": AppTheme.quizRush
                ])
                .frame(height: 180)
            }
        }
        .padding(20)
        .background(AppTheme.surfaceLight)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.primary.opacity(0.15), lineWidth: 1)
        )
    }
}

struct RecentGamesCard: View {
    let recentGames: [GameSession]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(AppTheme.teal)
                Text("Recent Games")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()

                if !recentGames.isEmpty {
                    Text("\(recentGames.count) games")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }

            if recentGames.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "clock")
                        .font(.system(size: 36))
                        .foregroundColor(AppTheme.textMuted)
                    Text("No recent games")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textSecondary)
                }
                .padding(.vertical, 20)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(recentGames.enumerated()), id: \.element.id) { index, session in
                        RecentGameRow(session: session)

                        if index < recentGames.count - 1 {
                            Divider()
                                .background(AppTheme.textMuted.opacity(0.3))
                                .padding(.leading, 56)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(AppTheme.surfaceLight)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.primary.opacity(0.15), lineWidth: 1)
        )
    }
}

struct RecentGameRow: View {
    let session: GameSession

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(modeColor.opacity(0.12))
                    .frame(width: 42, height: 42)

                Image(systemName: session.mode.icon)
                    .foregroundColor(modeColor)
                    .font(.body)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(session.mode.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.textPrimary)

                Text(session.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(session.score)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(modeColor)

                Text("points")
                    .font(.caption2)
                    .foregroundColor(AppTheme.textMuted)
            }
        }
        .padding(.vertical, 10)
    }

    var modeColor: Color {
        switch session.mode {
        case .tapFrenzy: return AppTheme.tapFrenzy
        case .lightItUp: return AppTheme.lightItUp
        case .quizRush: return AppTheme.quizRush
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
                .foregroundColor(AppTheme.primary)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 100)
    }
}
