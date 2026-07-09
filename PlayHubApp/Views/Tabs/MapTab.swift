
import Foundation
import SwiftUI
import MapKit

struct MapTab: View {
    @State private var sessions: [GameSession] = []
    @State private var selectedSession: GameSession?
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                ForEach(sessionsWithLocation) { session in
                    Marker(
                        "\(session.mode.rawValue): \(session.score)",
                        systemImage: session.mode.icon,
                        coordinate: CLLocationCoordinate2D(
                            latitude: session.latitude!,
                            longitude: session.longitude!
                        )
                    )
                    .tint(markerColor(for: session.mode))
                }
            }
            
            // show msg when no games played
            if sessionsWithLocation.isEmpty {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Image(systemName: "map")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        
                        Text("No Game Locations Yet")
                            .font(.headline)
                        
                        Text("Play games to see where you played!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Game Map")
        .onAppear {
            loadSessions()
        }
    }
    
    var sessionsWithLocation: [GameSession] {
        sessions.filter { $0.latitude != nil && $0.longitude != nil }
    }
    
    func loadSessions() {
        sessions = SessionManager.shared.loadSessions()
    }
    
    func markerColor(for mode: GameMode) -> Color {
        switch mode {
        case .tapFrenzy:
            return .orange
        case .lightItUp:
            return .yellow
        case .quizRush:
            return .green
        }
    }
}
