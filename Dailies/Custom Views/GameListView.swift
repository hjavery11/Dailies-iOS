//
//  GameListView.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import SwiftUI

struct GameListView: View {
    
    @ObservedObject var viewModel: HomeVM
    
    var body: some View {
        List(GameData().games, id: \.self) { game in
            Text(game.name)
                .onTapGesture {
                    viewModel.dailyGames.append(game)
                    UserManager.shared.addDailyGame(game)
                    viewModel.showGamesList = false
                }
        }
    }
   
    
}

#Preview {
    GameListView(viewModel: HomeVM())
}
