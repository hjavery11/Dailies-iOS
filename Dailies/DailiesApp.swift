//
//  DailiesApp.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import SwiftUI

@main
struct DailiesApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabView {
                GamesGridView()
                    .tabItem {
                        Label("Games", systemImage: "square.grid.3x3")
                    }
            }
        }
    }
}
