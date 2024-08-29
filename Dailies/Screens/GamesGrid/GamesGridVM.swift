//
//  GamesGridVM.swift
//  Dailies
//
//  Created by Harrison Javery on 8/26/24.
//

import Foundation

class GamesGridVM: ObservableObject {
    @Published var allGames = GameData().games
    let squareSize: CGFloat = 100
}
