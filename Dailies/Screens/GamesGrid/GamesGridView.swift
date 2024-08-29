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
    
    @StateObject private var viewModel = GamesGridVM()
   
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: gridItemWidth))
        ]

        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.allGames, id: \.self) { game in
                        NavigationLink(destination: WebViewScreen(games: $viewModel.allGames, currentIndex: viewModel.allGames.firstIndex(of: game) ?? 0)){
                            GameGridItem2(game: game, size: .large, completed: false)
                        }
                        .padding(.bottom)
                    }
                }
            }
            .padding([.trailing, .leading, .top], 12)            
            .navigationTitle("All Games")
        }
    }
}

#Preview {
    GamesGridView()
}




