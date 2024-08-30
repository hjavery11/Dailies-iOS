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
                    ForEach(userManager.games) { game in
                        GameGridItem2(game: game, size: .large, completed: false)
                            .padding(.bottom)
                    }
                }
                .navigationTitle("Choose Games")
                .padding([.trailing, .leading, .top], 12)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            confirmDailyGames()
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
