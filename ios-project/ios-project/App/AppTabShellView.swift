//
//  AppTab.swift
//  ios-project
//
//  Created by student6 on 2026-07-06.
//

import SwiftUI

struct AppTabShellView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeTabView()
            }
            .tabItem {
                Label("Home", systemImage: "gamecontroller.fill")
            }

            NavigationStack {
                StatsTabView()
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar.fill")
            }

            NavigationStack {
                MapTabView()
            }
            .tabItem {
                Label("Map", systemImage: "map.fill")
            }

            NavigationStack {
                SettingsTabView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}
