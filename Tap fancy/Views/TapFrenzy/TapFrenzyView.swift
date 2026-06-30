//
//  TapFrenzyView.swift
//  Tap fancy
//
//  Created by Piyumi Imalka on 2026-06-30.
//

import Foundation
import SwiftUI

// MARK: - TAP FRENZY GAME
struct TapFrenzyView: View {
    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var isGameActive = false
    @State private var highScore = HighScoreManager.getScore(for: "tapFrenzyHighScore")
    @State private var timer: Timer?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text("TAP FRENZY")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                                    
                    Text("High Score: \(highScore)")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 50)
                Spacer()
                
                if isGameActive {
                    gameView
                } else {
                    gameOverView
                }
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isGameActive)
        .toolbar {
            if !isGameActive {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Home")
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    var gameView: some View {
        VStack(spacing: 40) {
            Text("\(timeRemaining)")
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.white)
                
            VStack(spacing: 5) {
                Text("SCORE")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                Text("\(score)")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
            }
                
            Button(action: {
                handleTap()
            }) {
                Text("TAP!")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 200)
                    .background(Color.orange)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            }
        }
    }
    
    var gameOverView: some View {
        VStack(spacing: 30) {
            if score > 0 {
                VStack(spacing: 10) {
                    Text("GAME OVER!")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                                
                    Text("Final Score")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                                
                    Text("\(score)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.yellow)
                                
                    if score == highScore && score > 0 {
                        Text("🎉 NEW HIGH SCORE! 🎉")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                    }
                }
            } else {
                Text("Ready to Play?")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                startGame()
            }) {
                Text(score > 0 ? "PLAY AGAIN" : "START GAME")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(Color.green)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            }
        }
    }
    
    func startGame() {
        score = 0
        timeRemaining = 10
        isGameActive = true
               
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                endGame()
            }
        }
    }
    
    func handleTap() {
        score += 1
    }
    
    func endGame() {
        timer?.invalidate()
        timer = nil
        isGameActive = false
            
        if score > highScore {
            highScore = score
            HighScoreManager.save(score: highScore,
                                  for: "tapFrenzyHighScore")
        }
    }
}
