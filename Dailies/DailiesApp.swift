//
//  DailiesApp.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import SwiftUI

@main
struct DailiesApp: App {
    
    init() {
        UserManager.shared.setDailyGames()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {                
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "calendar")
                    }
                
                GamesGridView()
                    .tabItem {
                        Label("Games", systemImage: "square.grid.3x3")
                    }
                
               
            }
        }
    }
}
