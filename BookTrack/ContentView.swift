//
//  ContentView.swift
//  BookTrack
//
//  Created by Рома Котов on 02.10.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: DataStore
    
    var body: some View {
        TabView {
            LibraryView()
                .tabItem { Label("Library", systemImage: "books.vertical") }
            StatsGoalsView()
                .tabItem { Label("Stats", systemImage: "chart.bar") }
            ProfileSettingsView()
                .tabItem { Label("Profile", systemImage: "person.circle") }
        }
    }
}

#Preview {
    ContentView()
}
