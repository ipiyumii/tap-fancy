//
//  PlayHubApp.swift
//  PlayHubApp
//
//  Created by Piyumi Imalka on 2026-07-09.
//

import Foundation
import SwiftUI

@main
struct PlayHubApp: App {
    @StateObject private var locationService = LocationService.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    HomeTab()
                }
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Home")
                }
                
                NavigationStack {
                    StatsTab()
                }
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Stats")
                }
                
                NavigationStack {
                    MapTab()
                }
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                
                NavigationStack {
                    SettingsTab()
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
            .onAppear {
                locationService.requestPermission()
            }
        }
    }
}

