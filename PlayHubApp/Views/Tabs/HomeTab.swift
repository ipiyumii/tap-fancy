
import Foundation
import SwiftUI
struct HomeTab: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text("PlayHub")
                    .font(.system(size: 45, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Choose a Game")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.7))
                
                VStack(spacing: 18) {
                    NavigationLink(destination: TapFrenzyView()) {
                        GameButton(title: "Tap Frenzy", icon: "hand.tap.fill", color: .orange)
                    }
                    
                    NavigationLink(destination: LightItUpView()) {
                        GameButton(title: "Light It Up", icon: "lightbulb.fill", color: .yellow)
                    }
                    
                    NavigationLink(destination: QuizRushView()) {
                        GameButton(title: "Quiz Rush", icon: "questionmark.circle.fill", color: .green)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .padding(.top, 50)
        }
        .navigationBarHidden(true)
    }
}

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
