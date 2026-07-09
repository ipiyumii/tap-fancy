
import Foundation
import SwiftUI
import Charts

struct StatsTab: View {
    @StateObject private var viewModel = StatsVM()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Text("Overall Stats")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 30) {
                        StatBox(title: "Games", value: "\(viewModel.totalGames)")
                        StatBox(title: "Total Score", value: "\(viewModel.totalScore)")
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                
                VStack(spacing: 15) {
                    Text("Personal Bests")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(GameMode.allCases, id: \.self) { mode in
                        HStack {
                            Image(systemName: mode.icon)
                                .foregroundColor(.blue)
                            Text(mode.rawValue)
                            Spacer()
                            Text("\(viewModel.bestScore(for: mode))")
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                
                // chart 
                VStack(spacing: 15) {
                    Text("Scores by Game")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if viewModel.sessions.isEmpty {
                        Text("No games played yet")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        Chart(viewModel.sessions) { session in
                            BarMark(
                                x: .value("Game", session.timestamp, unit: .minute),
                                y: .value("Score", session.score)
                            )
                            .foregroundStyle(by: .value("Mode", session.mode.rawValue))
                        }
                        .frame(height: 200)
                        .padding()
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                
                VStack(spacing: 12) {
                    Text("Recent Games")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if viewModel.recentGames.isEmpty {
                        Text("No games played yet")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.recentGames) { session in
                            HStack {
                                Image(systemName: session.mode.icon)
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading) {
                                    Text(session.mode.rawValue)
                                        .fontWeight(.medium)
                                    Text(session.timestamp.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text("\(session.score)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal)
                            Divider()
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
            .padding()
        }
        .navigationTitle("Stats")
        .onAppear {
            viewModel.loadSessions()
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 100)
    }
}
