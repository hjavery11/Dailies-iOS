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
                        ZStack {
                            GameGridItem2(game: game, size: .large, showCompleted: false, result: nil)
                                .padding(.bottom)
                                .opacity(game.isDailyGame ? 0.5:1)
                                .onTapGesture {
                                    userManager.games[index].isDailyGame.toggle()
                                }
                            
                            if game.isDailyGame {
                                Image(systemName: "checkmark" )
                                    .foregroundStyle(Color(.systemGreen))
                                    .fontWeight(.semibold)
                                    .font(.title)
                                    .background(Color.clear)
                            }
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
