//
//  GameListView.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import SwiftUI

struct GameListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 150))
        ]
        
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(userManager.games.indices, id:\.self) { index in
                        let game = userManager.games[index]
                        //marking it as completed: true makes the checkmark appear which is what we want to happen, so just using that property eventhough its not technically its original intent
                        let selected = game.isDailyGame
                        GameGridItem2(game: game, size: .large, showCompleted: true, forceCompleted: selected)
                            .padding(.bottom)
                            .onTapGesture {
                                userManager.games[index].isDailyGame.toggle()
                            }
                    }
                }
                .navigationTitle("Choose Games")
                .padding([.trailing, .leading, .top], 12)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {                  
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    private func confirmDailyGames() {
        //        viewModel.dailyGames.append(game)
        //        UserManager.shared.addDailyGame(game)
        //        viewModel.showGamesList = false
    }
    
    
}

#Preview {
    GameListView()
}
