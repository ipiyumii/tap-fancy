import Foundation
import SwiftUI

@main
struct PlayHubApp: App {
    @StateObject private var locationService = LocationService.shared
    @State private var selectedTab = 0

        init() {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor.systemBackground

            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab){
                NavigationStack {
                    HomeTab()
                }
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "gamecontroller.fill" : "gamecontroller")
                        Text("Play")
                    }
                }
                .tag(0)
                
                NavigationStack {
                    StatsTab()
                }
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                        Text("Stats")
                    }
                }
                .tag(1)

                NavigationStack {
                    MapTab()
                }
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 2 ? "map.fill" : "map")
                        Text("Map")
                    }
                }
                .tag(2)

                NavigationStack {
                    SettingsTab()
                }
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                        Text("Settings")
                    }
                }
                .tag(3)
            }
            .tint(.purple)
            .onAppear {
                locationService.requestPermission()
            }
        }
    }
}

