
import Foundation
import SwiftUI

struct ResultView: View {
    let gameTitle: String
    let score: Int
    let highScore: Int
    let isNewHighScore: Bool
    let shareMessage: String
    let accentColor: Color
    let onPlayAgain: () -> Void
    @State private var showConfetti = false
    @State private var scoreScale: CGFloat = 0.5
    @State private var trophyRotation: Double = 0

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("GAME OVER!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)

                VStack(spacing: 8) {
                    Text("Your Score")
                        .font(.headline)
                        .foregroundColor(AppTheme.textSecondary)

                    Text("\(score)")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(AppTheme.accent)
                        .scaleEffect(scoreScale)
                }
                .padding()
                .background(AppTheme.surfaceLight)
                .cornerRadius(15)

                // high score trophy 
                HStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(AppTheme.accent)
                        .rotationEffect(.degrees(trophyRotation))

                    Text("High Score: \(highScore)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.textPrimary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(AppTheme.surfaceLight)
                .cornerRadius(10)

                if isNewHighScore {
                    VStack(spacing: 5) {
                        Text("NEW HIGH SCORE!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.accent)

                        HStack {
                            Text("🎉")
                            Text("Amazing!")
                                .font(.headline)
                                .foregroundColor(AppTheme.textSecondary)
                            Text("🎉")
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppTheme.accent.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppTheme.accent.opacity(0.5), lineWidth: 2)
                            )
                    )
                }

                // buttons
                VStack(spacing: 12) {
                    BouncingPlayButton(title: "PLAY AGAIN", color: accentColor) {
                        onPlayAgain()
                    }

                    ShareLink(item: shareMessage) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Score")
                        }
                        .font(.headline)
                        .foregroundColor(AppTheme.textOnColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppTheme.primaryLight)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
            }

            if showConfetti && isNewHighScore {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                scoreScale = 1.0
            }

            if isNewHighScore {
                showConfetti = true
                withAnimation(.easeInOut(duration: 0.5).repeatCount(3, autoreverses: true)) {
                    trophyRotation = 15
                }
            }
        }
    }
}

struct SimpleResultView: View {
    let score: Int
    let highScore: Int
    let isNewHighScore: Bool
    let buttonColor: Color
    let onPlayAgain: () -> Void
    @State private var scoreScale: CGFloat = 0.5
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            VStack(spacing: 25) {
                Text("GAME OVER!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)

                Text("Final Score")
                    .font(.headline)
                    .foregroundColor(AppTheme.textSecondary)

                Text("\(score)")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(AppTheme.accent)
                    .scaleEffect(scoreScale)

                HStack {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(AppTheme.accent)
                    Text("Best: \(highScore)")
                        .foregroundColor(AppTheme.textPrimary)
                }
                .font(.title3)

                if isNewHighScore {
                    VStack(spacing: 5) {
                        Text("🎉 NEW HIGH SCORE! 🎉")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.accent)

                        Text("You're on fire!")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding()
                    .background(AppTheme.accent.opacity(0.2))
                    .cornerRadius(12)
                }

                BouncingPlayButton(title: "PLAY AGAIN", color: buttonColor) {
                    onPlayAgain()
                }
            }

            if showConfetti && isNewHighScore {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                scoreScale = 1.0
            }

            if isNewHighScore {
                showConfetti = true
            }
        }
    }
}

// achievement badge 
struct AchievementBadge: View {
    let title: String
    let icon: String
    let color: Color
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? color : AppTheme.surfaceLight)
                    .frame(width: 60, height: 60)

                Image(systemName: isUnlocked ? icon : "lock.fill")
                    .font(.title2)
                    .foregroundColor(isUnlocked ? AppTheme.textOnColor : AppTheme.textMuted)
            }

            Text(title)
                .font(.caption)
                .foregroundColor(isUnlocked ? AppTheme.textPrimary : AppTheme.textMuted)
                .multilineTextAlignment(.center)
        }
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
}
