//
//  UIComponents.swift
//  Tap fancy
//
//  Created by Piyumi Imalka on 2026-07-21.
//

import Foundation
import SwiftUI

struct WelcomeBanner: View {
    let tips = [
        "Tap faster to score higher!",
        "Keep your streak going for bonus points!",
        "Challenge yourself daily!",
        "Beat your high score today!"
    ]

    @State private var currentTipIndex = 0
    @State private var opacity: Double = 1.0

    var body: some View {
        HStack {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.yellow)
                .font(.title3)

            Text(tips[currentTipIndex])
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .opacity(opacity)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.2))
        )
        .padding(.horizontal)
        .onAppear {
            startRotation()
        }
    }

    private func startRotation() {
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentTipIndex = (currentTipIndex + 1) % tips.count
                withAnimation(.easeIn(duration: 0.3)) {
                    opacity = 1
                }
            }
        }
    }
}

struct AnimatedGameCard: View {
    let title: String
    let icon: String
    let color: Color
    let description: String

    @State private var isPressed = false
    @State private var isPulsing = false

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 55, height: 55)
                    .scaleEffect(isPulsing ? 1.15 : 1.0)
                    .opacity(isPulsing ? 0.5 : 1.0)

                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            Image(systemName: "play.circle.fill")
                .font(.title)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [color, color.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: color.opacity(0.4), radius: isPressed ? 3 : 8, x: 0, y: isPressed ? 2 : 5)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}

struct CountdownOverlay: View {
    @Binding var isShowing: Bool
    let onComplete: () -> Void

    @State private var countdownValue = 3
    @State private var scale: CGFloat = 1.0

    var body: some View {
        if isShowing {
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Get Ready!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("\(countdownValue)")
                        .font(.system(size: 120, weight: .bold))
                        .foregroundColor(.yellow)
                        .scaleEffect(scale)

                    Text("Starting soon...")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .onAppear {
                startCountdown()
            }
        }
    }

    private func startCountdown() {
        countdownValue = 3
        animateNumber()

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdownValue > 1 {
                countdownValue -= 1
                animateNumber()
            } else {
                timer.invalidate()
                withAnimation {
                    isShowing = false
                }
                onComplete()
            }
        }
    }

    private func animateNumber() {
        scale = 1.5
        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
            scale = 1.0
        }
    }
}

struct ToastBanner: View {
    let message: String
    let icon: String
    let color: Color
    @Binding var isShowing: Bool

    var body: some View {
        if isShowing {
            VStack {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white)

                    Text(message)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color)
                        .shadow(color: color.opacity(0.5), radius: 10)
                )
                .padding(.top, 50)

                Spacer()
            }
            .transition(.move(edge: .top).combined(with: .opacity))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isShowing = false
                    }
                }
            }
        }
    }
}

struct GameStartSheet: View {
    let gameName: String
    let gameIcon: String
    let gameColor: Color
    let bestScore: Int
    let onStart: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 25) {
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(gameColor.opacity(0.2))
                        .frame(width: 100, height: 100)

                    Image(systemName: gameIcon)
                        .font(.system(size: 45))
                        .foregroundColor(gameColor)
                }

                Text(gameName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }

            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.yellow)
                    Text("Your Best: \(bestScore)")
                        .font(.headline)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }

            Text("Are you ready to play?")
                .font(.title3)
                .foregroundColor(.gray)

            HStack(spacing: 20) {
                Button(action: {
                    dismiss()
                }) {
                    Text("Not Now")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                }

                Button(action: {
                    dismiss()
                    onStart()
                }) {
                    Text("Let's Go!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(gameColor)
                        .cornerRadius(12)
                }
            }

            Spacer()
        }
        .padding(.top, 40)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

struct StreakBadge: View {
    let streakCount: Int
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "flame.fill")
                .foregroundColor(.orange)
                .scaleEffect(isAnimating ? 1.2 : 1.0)

            Text("\(streakCount)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.orange.opacity(0.3))
        )
        .onAppear {
            if streakCount >= 3 {
                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
        }
        .onChange(of: streakCount) { oldValue, newValue in
            if newValue >= 3 {
                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            } else {
                isAnimating = false
            }
        }
    }
}

struct BouncingPlayButton: View {
    let title: String
    let color: Color
    let action: () -> Void

    @State private var isBouncing = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 45)
                .padding(.vertical, 20)
                .background(color)
                .cornerRadius(20)
                .shadow(color: color.opacity(0.5), radius: 10, x: 0, y: 5)
        }
        .scaleEffect(isBouncing ? 1.05 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isBouncing = true
            }
        }
    }
}

struct DailyChallengeBanner: View {
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "star.circle.fill")
                        .font(.title2)
                        .foregroundColor(.yellow)

                    Text("Daily Challenge")
                        .font(.headline)
                        .foregroundColor(.white)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: isExpanded ? 15 : 15)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.pink, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                )
            }

            if isExpanded {
                VStack(spacing: 12) {
                    Text("Score 50+ in each game today!")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))

                    HStack(spacing: 20) {
                        ChallengeProgress(icon: "hand.tap.fill", completed: false)
                        ChallengeProgress(icon: "lightbulb.fill", completed: false)
                        ChallengeProgress(icon: "questionmark.circle.fill", completed: false)
                    }
                }
                .padding()
                .background(Color.purple.opacity(0.3))
                .cornerRadius(15)
                .padding(.top, -5)
            }
        }
        .padding(.horizontal)
    }
}

struct ChallengeProgress: View {
    let icon: String
    let completed: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(completed ? Color.green : Color.white.opacity(0.3))
                .frame(width: 45, height: 45)

            Image(systemName: completed ? "checkmark" : icon)
                .foregroundColor(.white)
                .font(.title3)
        }
    }
}

struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []

    var body: some View {
        ZStack {
            ForEach(confettiPieces) { piece in
                Circle()
                    .fill(piece.color)
                    .frame(width: piece.size, height: piece.size)
                    .position(piece.position)
                    .opacity(piece.opacity)
            }
        }
        .onAppear {
            createConfetti()
        }
    }

    private func createConfetti() {
        let colors: [Color] = [.red, .yellow, .green, .blue, .pink, .orange, .purple]

        for i in 0..<50 {
            let piece = ConfettiPiece(
                id: i,
                color: colors.randomElement()!,
                size: CGFloat.random(in: 5...12),
                position: CGPoint(x: CGFloat.random(in: 0...400), y: -20),
                opacity: 1.0
            )
            confettiPieces.append(piece)
        }

        for i in 0..<confettiPieces.count {
            let delay = Double.random(in: 0...0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeIn(duration: Double.random(in: 1.5...3))) {
                    confettiPieces[i].position.y = 900
                    confettiPieces[i].position.x += CGFloat.random(in: -50...50)
                    confettiPieces[i].opacity = 0
                }
            }
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id: Int
    let color: Color
    let size: CGFloat
    var position: CGPoint
    var opacity: Double
}
