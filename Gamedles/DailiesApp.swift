//
//  DailiesApp.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import SwiftUI

@main
struct DailiesApp: App {
    @StateObject var userManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Play", systemImage: "play.square.stack")
                    }
                
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "list.bullet.circle")
                    }
                
                GamesGridView()
                    .tabItem {
                        Label("Catalog", systemImage: "square.grid.3x3")
                    }
            }
            .environmentObject(userManager)
        }
    }
}
