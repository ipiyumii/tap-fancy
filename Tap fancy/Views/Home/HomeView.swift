import SwiftUI

struct HomeView: View {
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {

                // Header
                VStack(spacing: 10) {
                    Text("🎮")
                        .font(.system(size: 80))

                    Text("GAME CENTER")
                        .font(.system(size: 45, weight: .bold))
                        .foregroundColor(.white)

                    Text("Choose Your Challenge")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 80)

                Spacer()

                // Game Buttons
                VStack(spacing: 30) {

                    NavigationLink(destination: TapFrenzyView()) {
                        GameModeButton(
                            title: "TAP FRENZY",
                            subtitle: "Tap as fast as you can!",
                            icon: "hand.tap.fill",
                            color: .orange
                        )
                    }

                    NavigationLink(destination: LightItUpView()) {
                        GameModeButton(
                            title: "LIGHT IT UP",
                            subtitle: "Catch the glowing card!",
                            icon: "lightbulb.fill",
                            color: .yellow
                        )
                    }
                    
                    NavigationLink(destination: QuizRushView()) {
                        GameModeButton(
                            title: "QUIZ RUSH",
                            subtitle: "Answer trivia questions!",
                            icon: "brain.head.profile",
                            color: .green
                        )
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
