
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
    
    var body: some View {
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
            }
            .padding()
            .background(Color.white.opacity(0.15))
            .cornerRadius(15)
            
            HStack(spacing: 8) {
                Image(systemName: "trophy.fill")
                    .foregroundColor(.yellow)
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
                Text("🎉 NEW HIGH SCORE! 🎉")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                    .padding(.top, 5)
            }
            
            // btns
            VStack(spacing: 12) {
                Button(action: onPlayAgain) {
                    Text("PLAY AGAIN")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(accentColor)
                        .cornerRadius(12)
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
    }
}

struct SimpleResultView: View {
    let score: Int
    let highScore: Int
    let isNewHighScore: Bool
    let buttonColor: Color
    let onPlayAgain: () -> Void
    
    var body: some View {
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
            
            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundColor(.yellow)
                Text("Best: \(highScore)")
                    .foregroundColor(.white)
            }
            .font(.title3)
            
            if isNewHighScore {
                Text("🎉 NEW HIGH SCORE! 🎉")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
            }
            
            Button(action: onPlayAgain) {
                Text("PLAY AGAIN")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(buttonColor)
                    .cornerRadius(15)
            }
        }
    }
}
