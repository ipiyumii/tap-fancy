
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
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(AppTheme.accent.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: "lightbulb.fill")
                    .foregroundColor(AppTheme.accent)
                    .font(.body)
            }

            Text(tips[currentTipIndex])
                .font(.subheadline)
                .foregroundColor(AppTheme.textPrimary)
                .opacity(opacity)

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.surfaceLight)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppTheme.primary.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
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

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.textPrimary)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundColor(AppTheme.textMuted)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.surfaceLight)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.primary.opacity(0.15), lineWidth: 1)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
    }
}

struct QuickGamePreview: View {
    let gameName: String
    let gameIcon: String
    let gameColor: Color
    @Binding var isShowing: Bool
    let onStart: () -> Void

    @State private var countdown = 3
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0

    var body: some View {
        if isShowing {
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        startGame()
                    }

                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [gameColor, gameColor.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)

                        Image(systemName: gameIcon)
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                    .shadow(color: gameColor.opacity(0.5), radius: 15, x: 0, y: 5)

                    Text(gameName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    // Countdown
                    Text("Starting in \(countdown)...")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))

                    // Progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 6)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(gameColor)
                                .frame(width: geo.size.width * CGFloat(3 - countdown) / 3, height: 6)
                                .animation(.linear(duration: 1), value: countdown)
                        }
                    }
                    .frame(height: 6)
                    .frame(width: 150)

                    Text("Tap anywhere to start now")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(AppTheme.surfaceElevated)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(gameColor.opacity(0.3), lineWidth: 1)
                )
                .scaleEffect(scale)
                .opacity(opacity)
            }
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    scale = 1.0
                    opacity = 1.0
                }
                startCountdown()
            }
        }
    }

    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
            } else {
                timer.invalidate()
                startGame()
            }
        }
    }

    private func startGame() {
        withAnimation(.easeOut(duration: 0.2)) {
            scale = 1.1
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isShowing = false
            onStart()
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
                Color.black.opacity(0.8)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Get Ready!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.textOnColor)

                    Text("\(countdownValue)")
                        .font(.system(size: 120, weight: .bold))
                        .foregroundColor(AppTheme.accent)
                        .scaleEffect(scale)

                    Text("Starting soon...")
                        .font(.headline)
                        .foregroundColor(AppTheme.textOnColor.opacity(0.7))
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
                        .foregroundColor(AppTheme.textOnColor)

                    Text(message)
                        .font(.headline)
                        .foregroundColor(AppTheme.textOnColor)
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
        VStack(spacing: 30) {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [gameColor, gameColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)

                    Image(systemName: gameIcon)
                        .font(.system(size: 45))
                        .foregroundColor(.white)
                }
                .shadow(color: gameColor.opacity(0.4), radius: 12, x: 0, y: 6)

                Text(gameName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.textPrimary)
            }

            HStack(spacing: 12) {
                Image(systemName: "trophy.fill")
                    .foregroundColor(AppTheme.accent)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Your Best")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                    Text("\(bestScore)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.textPrimary)
                }

                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.surfaceLight)
            )
            .padding(.horizontal, 40)

            Text("Ready to play?")
                .font(.body)
                .foregroundColor(AppTheme.textSecondary)

            VStack(spacing: 12) {
                Button(action: {
                    dismiss()
                    onStart()
                }) {
                    Text("Start Game")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(gameColor)
                        )
                        .shadow(color: gameColor.opacity(0.4), radius: 8, x: 0, y: 4)
                }

                Button(action: {
                    dismiss()
                }) {
                    Text("Not Now")
                        .font(.headline)
                        .foregroundColor(AppTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .padding(.horizontal, 30)

            Spacer()
        }
        .padding(.top, 40)
        .background(AppTheme.surface.ignoresSafeArea())
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
                .foregroundColor(AppTheme.accent)
                .scaleEffect(isAnimating ? 1.2 : 1.0)

            Text("\(streakCount)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.textPrimary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(AppTheme.accent.opacity(0.3))
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
                .foregroundColor(AppTheme.textOnColor)
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
                    ZStack {
                        Circle()
                            .fill(AppTheme.accent)
                            .frame(width: 40, height: 40)

                        Image(systemName: "star.fill")
                            .font(.body)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Daily Challenge")
                            .font(.headline)
                            .foregroundColor(AppTheme.textPrimary)

                        Text("Complete all games today")
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(AppTheme.textMuted)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppTheme.surfaceLight)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppTheme.accent.opacity(0.3), lineWidth: 1)
                )
            }

            if isExpanded {
                VStack(spacing: 12) {
                    Text("Score 50+ in each game today!")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textPrimary)

                    HStack(spacing: 20) {
                        ChallengeProgress(icon: "hand.tap.fill", color: AppTheme.tapFrenzy, completed: false)
                        ChallengeProgress(icon: "lightbulb.fill", color: AppTheme.lightItUp, completed: false)
                        ChallengeProgress(icon: "questionmark.circle.fill", color: AppTheme.quizRush, completed: false)
                    }
                }
                .padding()
                .background(AppTheme.surface)
                .cornerRadius(16)
                .padding(.top, -8)
            }
        }
        .padding(.horizontal)
    }
}

struct ChallengeProgress: View {
    let icon: String
    let color: Color
    let completed: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(completed ? AppTheme.success.opacity(0.2) : color.opacity(0.2))
                .frame(width: 48, height: 48)

            Image(systemName: completed ? "checkmark" : icon)
                .foregroundColor(completed ? AppTheme.success : color)
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
        let colors: [Color] = AppTheme.confettiColors

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
