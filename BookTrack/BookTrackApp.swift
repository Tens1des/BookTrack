//
//  BookTrackApp.swift
//  BookTrack
//
//  Created by Рома Котов on 02.10.2025.
//

import SwiftUI

@main
struct BookTrackApp: App {
    @StateObject private var store = DataStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .preferredColorScheme(store.settings.theme == .dark ? .dark : (store.settings.theme == .light ? .light : nil))
        }
    }
}
