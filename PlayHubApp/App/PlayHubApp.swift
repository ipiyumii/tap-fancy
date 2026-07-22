import Foundation
import SwiftUI

@main
struct PlayHubApp: App {
    @StateObject private var locationService = LocationService.shared
    @State private var selectedTab = 0

    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color(hex: "1A1625"))

        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color(hex: "6B6680"))
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color(hex: "6B6680"))]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color(hex: "8B5CF6"))
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color(hex: "8B5CF6"))]

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(Color(hex: "0F0D1A"))
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
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
                    ProfileTab()
                }
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                        Text("Profile")
                    }
                }
                .tag(3)

                NavigationStack {
                    SettingsTab()
                }
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                        Text("Settings")
                    }
                }
                .tag(4)
            }
            .tint(Color(hex: "8B5CF6"))
            .onAppear {
                locationService.requestPermission()
            }
        }
    }
}

