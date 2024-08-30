//
//  ContentView.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import SwiftUI

let gridItemWidth: CGFloat = 150
let gridItemHeight: CGFloat = 130

struct GamesGridView: View {
    
    @StateObject private var viewModel = GamesVM()
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: gridItemWidth))
        ]
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(userManager.games.indices, id:\.self) { index in
                        let game = userManager.games[index]
                        NavigationLink(value: index) {
                            GameGridItem2(game: game, size: .large, showCompleted: false, forceCompleted: false)
                        }
                        .padding(.bottom)
                    }
                }
                .padding([.trailing, .leading, .top], 12)
                .navigationTitle("All Games")
            }
            .navigationDestination(for: Int.self) { index in
                WebViewScreen(index: index, dailiesOnly: false)
            }
        }
    }
}

#Preview {
    GamesGridView()
}




