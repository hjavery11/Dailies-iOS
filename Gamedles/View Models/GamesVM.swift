//
//  HomeVM.swift
//  Dailies
//
//  Created by Harrison Javery on 8/28/24.
//

import SwiftUI
import Combine

class GamesVM: ObservableObject {
    
    @Published var showGamesList: Bool = false
    @Published var currentIndex: Int = 0
    
    func goToNextGame() {
//        if currentIndex + 1 < dailyGames.count {
//            currentIndex += 1
//        }
    }
    
    func setCurrentGame(at index: Int) {
//        if index >= 0 && index < dailyGames.count {
//            currentIndex = index
//            selectedGame = dailyGames[index]
//        }
    }
}
