import SwiftUI

struct ContentView: View {
    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var isGameActive = false
    @State private var highScore = UserDefaults.standard.integer(forKey: "highScore")
    @State private var timer: Timer?
    @State private var buttonOffset = CGSize.zero
    
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
    }
    
    var gameView: some View {
        VStack(spacing: 40) {
            //timer
            Text("\(timeRemaining)")
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.white)
                
            //Score
            VStack(spacing: 5) {
                Text("SCORE")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                Text("\(score)")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
            }
                
            //button
            Button(action: {
                handleTap()
            }) {
                Text("TAP!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
                    .background(Color.orange)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .offset(buttonOffset)
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
                        Text("NEW HIGH SCORE!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                    }
                }
            } else {
                // Welcome screen
                Text("Ready to Play?")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            
            // Play Again / Start Button
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
        //reset state
        score = 0
        timeRemaining = 10
        isGameActive = true
        buttonOffset = CGSize.zero
        
        //start timer
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
        moveButton()
    }
    
    func moveButton() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            buttonOffset = CGSize(
                width: CGFloat.random(in: -100...100),
                height: CGFloat.random(in: -150...150)
            )
        }
    }
    
    func endGame() {
        timer?.invalidate()
        timer = nil
        isGameActive = false
        
        //update high score
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScore")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
