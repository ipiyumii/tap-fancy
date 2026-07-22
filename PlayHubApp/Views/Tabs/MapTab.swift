
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
                            .foregroundColor(AppTheme.primary)

                        Text("No Game Locations Yet")
                            .font(.headline)

                        Text("Play games to see where you played!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground).opacity(0.95))
                    .cornerRadius(12)
                    .shadow(color: AppTheme.primary.opacity(0.2), radius: 5)

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
            return AppTheme.tapFrenzy
        case .lightItUp:
            return AppTheme.lightItUp
        case .quizRush:
            return AppTheme.quizRush
        }
    }
}
