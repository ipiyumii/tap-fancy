
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
                    .foregroundColor(.white)

                VStack(spacing: 8) {
                    Text("Your Score")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))

                    Text("\(score)")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.yellow)
                        .scaleEffect(scoreScale)
                }
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(15)

                // high scoretrophy 
                HStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.yellow)
                        .rotationEffect(.degrees(trophyRotation))

                    Text("High Score: \(highScore)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)

                if isNewHighScore {
                    VStack(spacing: 5) {
                        Text("NEW HIGH SCORE!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)

                        HStack {
                            Text("🎉")
                            Text("Amazing!")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                            Text("🎉")
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.yellow.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.yellow.opacity(0.5), lineWidth: 2)
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
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
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
                    .foregroundColor(.white)

                Text("Final Score")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))

                Text("\(score)")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.yellow)
                    .scaleEffect(scoreScale)

                HStack {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.yellow)
                    Text("Best: \(highScore)")
                        .foregroundColor(.white)
                }
                .font(.title3)

                if isNewHighScore {
                    VStack(spacing: 5) {
                        Text("🎉 NEW HIGH SCORE! 🎉")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)

                        Text("You're on fire!")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.2))
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
                    .fill(isUnlocked ? color : Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)

                Image(systemName: isUnlocked ? icon : "lock.fill")
                    .font(.title2)
                    .foregroundColor(isUnlocked ? .white : .gray)
            }

            Text(title)
                .font(.caption)
                .foregroundColor(isUnlocked ? .white : .gray)
                .multilineTextAlignment(.center)
        }
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
}
