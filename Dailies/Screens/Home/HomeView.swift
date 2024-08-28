//
//  HomeView.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeVM()
    
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
        
        if let dailyGames = viewModel.dailyGames {
            let gamesList = dailyGames.keys.compactMap { GameData.shared.getGame(forName: $0) }
            
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(gamesList.enumerated()), id: \.element.name) { index, game in
                                ZStack {
                                    HStack {
                                        NavigationLink(destination: WebViewScreen(games: gamesList, currentIndex: index)) {
                                            GameGridItem2(game: game, size: .small, completed: dailyGames[game.name] ?? false)
                                        }
                                    }
                                    if dailyGames[game.name] == true {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(Color(.systemGreen))
                                            .fontWeight(.semibold)
                                            .font(.title)
                                            .background(Color.clear)
                                    }
                                }
                        }
                        .navigationTitle("Daily Games")
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
