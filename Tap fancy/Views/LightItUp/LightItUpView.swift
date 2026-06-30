//
//  LightItUpView.swift
//  Tap fancy
//
//  Created by Piyumi Imalka on 2026-06-30.
//

import Foundation
import SwiftUI


struct LightItUpView: View {
    @State private var cards: [Card] = []
    @State private var score = 0
    @State private var timeRemaining = 60
    @State private var isGameActive = false
    @State private var highScore = UserDefaults.standard.integer(forKey: "lightItUpHighScore")
    @State private var timer: Timer?
    @State private var lightTimer: Timer?
    @State private var gridColumns = 3
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
                    
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Text("LIGHT IT UP")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                            
                    Text("High Score: \(highScore)")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 20)
                            
                if isGameActive {
                    activeGameView
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
    
    var activeGameView: some View {
        VStack(spacing: 20) {
            HStack(spacing: 50) {
                VStack {
                    Text("TIME")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    Text("\(timeRemaining)")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                }
                        
                VStack {
                    Text("SCORE")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    Text("\(score)")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 20)
                    
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: gridColumns), spacing: 15) {
                ForEach(cards) { card in
                    CardView(isLit: card.isLit)
                        .onTapGesture {
                            handleCardTap(card)
                        }
                }
            }
            .padding()
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
                VStack(spacing: 15) {
                    Text("Ready to Play?")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                            
                    Text("Tap the glowing card before it goes dark!")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
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
        timeRemaining = 60
        isGameActive = true
        gridColumns = 3
        cards = (0..<9).map { _ in Card() }
            
        // Main game timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                
                // Increase difficulty as time progresses
                if timeRemaining == 45 {
                    gridColumns = 4
                    cards = (0..<16).map { _ in Card() }
                } else if timeRemaining == 30 {
                    gridColumns = 5
                    cards = (0..<25).map { _ in Card() }
                }
            } else {
                endGame()
            }
        }
        
        // Start lighting up random cards
        lightRandomCard()
        lightTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            lightRandomCard()
        }
    }
    
    func lightRandomCard() {
        // Turn off all lit cards
        for index in cards.indices {
            cards[index].isLit = false
        }
        
        // Light up a random card
        if let randomIndex = cards.indices.randomElement() {
            withAnimation {
                cards[randomIndex].isLit = true
            }
        }
    }
    
    func handleCardTap(_ card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
           
        if cards[index].isLit {
            withAnimation {
                score += 1
                cards[index].isLit = false
            }
        } else {
            withAnimation {
                score = max(0, score - 1)
            }
        }
    }
    
    func endGame() {
        timer?.invalidate()
        timer = nil
        lightTimer?.invalidate()
        lightTimer = nil
        isGameActive = false
           
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "lightItUpHighScore")
        }
    }
}
