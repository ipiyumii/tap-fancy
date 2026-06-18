import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            HomeView()
        }
    }
}

struct HomeView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(spacing: 10) {
                    Text("🎮").font(.system(size: 80))
                    Text("GAME CENTER").font(.system(size: 45, weight: .bold)).foregroundColor(.white)
                    Text("Choose Your Challenge").font(.headline).foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 80)
                Spacer()
                
                VStack(spacing: 30) {
                    NavigationLink(destination: TapFrenzyView()) {
                        GameModeButton( title: "TAP FRENZY", subtitle: "Tap as fast as you can!",icon: "hand.tap.fill",color: .orange
                    )}
                    
                    NavigationLink(destination: LightItUpView()) {
                        GameModeButton(title: "LIGHT IT UP", subtitle: "Catch the glowing card!", icon: "lightbulb.fill", color: .yellow
                    )}
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(false)
    }
}

struct GameModeButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .frame(width: 60)
            
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
            }
        Spacer()
                        
        Image(systemName: "chevron.right")
            .foregroundColor(.white.opacity(0.7))
        }
        
        .padding(25)
        .background(color)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct TapFrenzyView: View {
    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var isGameActive = false
    @State private var highScore = UserDefaults.standard.integer(forKey: "tapFrenzyHighScore")
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
            UserDefaults.standard.set(highScore, forKey: "tapFrenzyHighScore")
        }
    }
}

struct Card: Identifiable {
    let id = UUID()
    var isLit: Bool = false
}

struct LightItUpView: View {
    @State private var cards: [Card] = []
    @State private var score = 0
    @State private var timeRemaining = 60
    @State private var isGameActive = false
    @State private var highScore = UserDefaults.standard.integer(forKey: "lightItUpHighScore")
    @State private var timer: Timer?
    @State private var gridColumns = 3
    @Environment(\.dismiss) var dismiss
    
    var body: some View  {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]),startPoint: .topLeading,endPoint: .bottomTrailing)
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
    
    var activeGameView: some View{
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
                ForEach(cards) { card in CardView(isLit: card.isLit) .onTapGesture {
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
                        Text("NEW HIGH SCORE!")
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
        cards = (0..<3).map { _ in Card() }
            
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
        if timeRemaining > 0 {
            timeRemaining -= 1
            } else {
                endGame()
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
        isGameActive = false
           
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "lightItUpHighScore")
        }
    }
}

struct CardView: View {
    let isLit: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(isLit ? Color.yellow : Color.white.opacity(0.3))
            .frame(height: 120)
            .shadow(color: isLit ? Color.yellow.opacity(0.6) : Color.clear, radius: 10)
            .scaleEffect(isLit ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isLit)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

    
    
